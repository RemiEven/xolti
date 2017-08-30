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

require 'core/core'
require 'core/config'
require 'core/file_finder'
require 'core/resources'
require 'core/version'
require 'core/print_utils'

Signal.trap('INT') do
	puts '\nCancelling...'
	exit 1
end

# Command line client
class XoltiCLI < Thor
	desc 'add [FILE|FOLDER]', 'Add a header to FILE or to all files in FOLDER'
	# Add a header to a set of files
	#
	# @param [String] file the path to the file or the folder containing the files where to add headers
	def add(file)
		config = load_config_or_exit
		if File.file?(file)
			PrintUtils.puts "Adding header to #{file}"
			Core.licensify(file, config) unless Core.header?(file, config)
		else
			FileFinder.explore_folder(file)
				.reject { |source_file| Core.header?(source_file, config) }
				.each do |source_file|
					PrintUtils.puts "Adding header to #{source_file}"
					Core.licensify(source_file, config)
				end
		end
	end

	desc 'status [FILE|FOLDER]', 'Check the header of FILE or to all files in FOLDER; FOLDER defaults to current one'
	# Check the header of a set to file
	#
	# @param [String] file the path to the file or the folder containing the files where to check for headers
	def status(file = '.')
		config = load_config_or_exit
		if File.file?(file)
			PrintUtils.puts check_file(file, config) || 'Correct header'
		else
			FileFinder.explore_folder(file)
				.each do |source_file|
					message = check_file(source_file, config)
					next unless message
					PrintUtils.puts source_file.to_s
					PrintUtils.puts(message, 1)
					PrintUtils.puts ''
				end
		end
	end

	desc 'list-missing', 'Print a list of files missing (proper) header'
	# List all files without header in the current directory
	def list_missing
		dir = Dir.pwd
		config = load_config_or_exit
		missing_headers = FileFinder.explore_folder(dir)
			.reject { |file| Core.header?(file, config) }
		return PrintUtils.puts 'All files OK' if missing_headers.empty?
		PrintUtils.puts 'Files missing (proper) header:'
		PrintUtils.puts(missing_headers.map { |file| file.sub(dir + '/', '') }, 1)
	end

	desc 'delete [FILE|FOLDER]', 'Delete the header in FILE or to all files in FOLDER'
	# Delete headers in a set of files
	#
	# @param [String] file the path to the file or the folder containing the files where to delete headers
	def delete(file)
		config = load_config_or_exit
		if File.file?(file)
			PrintUtils.puts "Deleting header in #{file}"
			Core.delete_header(file, config)
		else
			FileFinder.explore_folder(file)
				.each do |source_file|
					PrintUtils.puts "Deleting header in #{source_file}"
					Core.delete_header(source_file, config)
				end
		end
	end

	desc 'generate-license', 'Generate a LICENSE file containing a full license'
	# Generate a LICENSE file containing a full license
	def generate_license
		config = load_config_or_exit
		filename = 'LICENSE'
		if File.exist?(File.join(Dir.pwd, filename))
			PrintUtils.puts "There is already a #{filename} file. Abort generation."
		else
			full_license = IO.binread(Resources.get_full_license_path(config.license))
			File.write(filename, full_license % config.project_info)
			PrintUtils.puts "Created the #{filename} file (#{config.license})"
		end
	end

	map ['--version', '-v'] => :__print_version

	desc '--version, -v', 'Print version of xolti'
	# Print the current version of xolti
	def __print_version
		puts XoltiVersion.get
	end

	map ['--license', '-l'] => :__print_license

	desc '--license, -l', 'Print licensing information of xolti'
	# Print licensing information of xolti
	def __print_license
		puts "Xolti version #{XoltiVersion.get}, Copyright (C) 2016, 2017 Rémi Even"
		puts 'Xolti comes with ABSOLUTELY NO WARRANTY.'
		puts 'This is free software, and you are welcome to redistribute it'
		puts 'under the terms of the GPLv3.'
		puts 'The complete license can be found at \'https://www.gnu.org/licenses/gpl.txt\'.'
		puts 'The source code of xolti can be found at \'https://github.com/RemiEven/xolti\'.'
	end

	no_commands do
		def ask_for_name(config)
			default_name = Pathname.getwd.basename.to_s
			print "name (#{default_name}): "
			typed_name = STDIN.gets.chomp
			config['project_info']['project_name'] = typed_name == '' ? default_name : typed_name
		end

		def ask_for_author(config)
			print 'author: '
			typed_author = STDIN.gets.chomp
			config['project_info']['author'] = typed_author
		end

		def ask_for_license(config)
			default_license = 'GPL3.0'
			print "license (#{default_license}): "
			typed_license = STDIN.gets.chomp
			config['license'] = typed_license == '' ? default_license : typed_license
		end

		def load_config
			return XoltiConfig.load_config
		rescue StandardError => e
			yield e if block_given?
		end

		def load_config_or_exit
			load_config do |e|
				puts e.message
				exit 1
			end
		end

		def check_file(file, config)
			diffs = Core.validate_header(file, config)
			result = []
			diffs.each do |diff|
				return ['No header found.'] if diff[:type] && diff[:type] == :no_header_found
				result << "Line #{diff[:line_number]}: expected \"#{diff[:expected]}\" but got \"#{diff[:actual]}\"."
			end
			return result unless diffs.empty?
		end
	end

	desc 'init', 'Create xolti.yml'
	# Init a xolti project by creating a xolti.yml file
	def init
		config = load_config
		return PrintUtils.puts 'Xolti is already initialized' unless config.nil?
		PrintUtils.puts 'Initializing xolti project'
		config = { 'project_info' => {} }
		ask_for_name(config)
		ask_for_author(config)
		ask_for_license(config)
		File.write('xolti.yml', config.to_yaml)
	end
end
