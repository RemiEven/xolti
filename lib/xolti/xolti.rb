# xolti.rb
# Copyright (C) Rémi Even 2016, 2017
#
# This file is part of Xolti.
#
# Xolti is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Xolti is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Xolti. If not, see <http://www.gnu.org/licenses/>.

require 'thor'
require 'pathname'
require 'yaml'

require 'xolti/core/core'
require 'xolti/core/config'
require 'xolti/core/file_finder'
require 'xolti/core/resources'
require 'xolti/core/version'
require 'xolti/core/print_utils'

Signal.trap('INT') do
	puts '\nCancelling...'
	exit 1
end

# Top-level Xolti module
module Xolti
	# Command line client
	class CLI < Thor
		desc 'add [FILE|FOLDER]', 'Add a header to FILE or to all files in FOLDER'
		# Add a header to a set of files
		#
		# @param [String] file the path to the file or the folder containing the files where to add headers
		def add(file)
			exit_if_file_missing(file)
			config = load_config_or_exit
			if File.file?(file)
				add_header_if_missing(file, config)
			else
				Xolti::FileFinder.explore_folder(file).each do |source_file|
					add_header_if_missing(source_file, config)
				end
			end
		end

		desc 'status [FILE|FOLDER]', 'Check the header of FILE or to all files in FOLDER; FOLDER defaults to current one'
		# Check the header of a set to file
		#
		# @param [String] file the path to the file or the folder containing the files where to check for headers
		def status(file = '.')
			exit_if_file_missing(file)
			config = load_config_or_exit
			if File.file?(file)
				Xolti::PrintUtils.puts check_file(file, config) || 'Correct header'
			else
				Xolti::FileFinder.explore_folder(file)
					.each do |source_file|
						message = check_file(source_file, config)
						next unless message
						Xolti::PrintUtils.puts source_file.to_s
						Xolti::PrintUtils.puts(message, 1)
						Xolti::PrintUtils.puts ''
					end
			end
		end

		desc 'list-missing', 'Print a list of files missing (proper) header'
		# List all files without header in the current directory
		def list_missing
			dir = Dir.pwd
			config = load_config_or_exit
			missing_headers = Xolti::FileFinder.explore_folder(dir)
				.reject { |file| Xolti::Core.header?(file, config) }
			return Xolti::PrintUtils.puts 'All files OK' if missing_headers.empty?
			Xolti::PrintUtils.puts 'Files missing (proper) header:'
			Xolti::PrintUtils.puts(missing_headers.map { |file| file.sub(dir + '/', '') }, 1)
		end

		desc 'delete [FILE|FOLDER]', 'Delete the header in FILE or to all files in FOLDER'
		# Delete headers in a set of files
		#
		# @param [String] file the path to the file or the folder containing the files where to delete headers
		def delete(file)
			exit_if_file_missing(file)
			config = load_config_or_exit
			if File.file?(file)
				delete_header_if_present(file, config)
			else
				Xolti::FileFinder.explore_folder(file).each do |source_file|
					delete_header_if_present(source_file, config)
				end
			end
		end

		desc 'generate-license', 'Generate a LICENSE file containing a full license'
		# Generate a LICENSE file containing a full license
		def generate_license
			config = load_config_or_exit
			filename = 'LICENSE'
			if File.exist?(File.join(Dir.pwd, filename))
				Xolti::PrintUtils.puts "There is already a #{filename} file. Abort generation."
			else
				full_license = IO.binread(Xolti::Resources.get_full_license_path(config.license))
				File.write(filename, full_license % config.project_info)
				Xolti::PrintUtils.puts "Created the #{filename} file (#{config.license})"
			end
		end

		map ['--version', '-v'] => :__print_version

		desc '--version, -v', 'Print version of xolti'
		# Print the current version of xolti
		def __print_version
			puts Xolti::Version.get
		end

		map ['--license', '-l'] => :__print_license

		desc '--license, -l', 'Print licensing information of xolti'
		# Print licensing information of xolti
		def __print_license
			puts "Xolti version #{Xolti::Version.get}, Copyright (C) 2016, 2017 Rémi Even"
			puts 'Xolti comes with ABSOLUTELY NO WARRANTY.'
			puts 'This is free software, and you are welcome to redistribute it'
			puts 'under the terms of the GPLv3.'
			puts 'The complete license can be found at \'https://www.gnu.org/licenses/gpl.txt\'.'
			puts 'The source code of xolti can be found at \'https://github.com/RemiEven/xolti\'.'
		end

		no_commands do
			def add_header_if_missing(file, config)
				if Xolti::Core.header?(file, config)
					Xolti::PrintUtils.puts "#{file} already has a header"
				else
					Xolti::PrintUtils.puts "Adding header to #{file}"
					Xolti::Core.licensify(file, config)
				end
			end

			def delete_header_if_present(file, config)
				if Xolti::Core.header?(file, config)
					Xolti::PrintUtils.puts "Deleting header in #{file}"
					Xolti::Core.delete_header(file, config)
				else
					Xolti::PrintUtils.puts "No header found in #{file}"
				end
			end

			def ask_for_name(config)
				default_name = Pathname.getwd.basename.to_s
				print "name (#{default_name}): "
				typed_name = STDIN.gets.chomp
				config['project']['name'] = typed_name == '' ? default_name : typed_name
			end

			def ask_for_author(config)
				print 'author: '
				typed_author = STDIN.gets.chomp
				config['project']['author'] = typed_author
			end

			def ask_for_license(config)
				default_license = 'GPL3.0'
				print "license (#{default_license}): "
				typed_license = STDIN.gets.chomp
				config['license'] = typed_license == '' ? default_license : typed_license
			end

			def load_config
				return Xolti::Config.load_config
			rescue StandardError => e
				yield e if block_given?
			end

			def load_config_or_exit
				load_config do |e|
					exit_with_message e.message
				end
			end

			def check_file(file, config)
				diffs = Xolti::Core.validate_header(file, config)
				result = []
				diffs.each do |diff|
					return ['No header found.'] if diff[:type] && diff[:type] == :no_header_found
					result << "Line #{diff[:line_number]}: expected \"#{diff[:expected]}\" but got \"#{diff[:actual]}\"."
				end
				return result unless diffs.empty?
			end

			def exit_if_file_missing(file)
				exit_with_message "File not found: '#{file}'" unless File.exist?(file)
			end

			def exit_with_message(message)
				Xolti::PrintUtils.puts message
				exit 1
			end
		end

		desc 'init', 'Create xolti.yml'
		# Init a xolti project by creating a xolti.yml file
		def init
			config = load_config
			return Xolti::PrintUtils.puts 'Xolti is already initialized' unless config.nil?
			Xolti::PrintUtils.puts 'Initializing xolti project'
			config = { 'project' => {} }
			ask_for_name(config)
			ask_for_author(config)
			ask_for_license(config)
			File.write('xolti.yml', config.to_yaml)
		end
	end
end
