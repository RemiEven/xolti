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

require_relative 'core/core'
require_relative 'core/config'
require_relative 'core/file_finder'
require_relative 'core/resources'
require_relative 'core/version'
require_relative 'core/print_utils'

Signal.trap('INT') do
	puts '\nCancelling...'
	exit 1
end

class XoltiCLI < Thor

	desc 'add [FILE|FOLDER]', 'Add a header to FILE or to all files in FOLDER'
	def add(file)
		config = self.load_config {|e| puts e.message; exit 1 }
		if File.file?(file)
			PrintUtils.puts_single "Adding header to #{file}"
			Core.licensify(file, config) if !Core.has_header(file, config)
		else
			FileFinder.explore_folder(file)
				.reject{|source_file| Core.has_header(source_file, config)}
				.each do |source_file|
					PrintUtils.puts_single "Adding header to #{source_file}"
					Core.licensify(source_file, config)
				end
		end
	end

	desc 'status [FILE|FOLDER]', 'Check the header of FILE or to all files in FOLDER; FOLDER default to current one'
	def status(file = '.')
		config = self.load_config {|e| puts e; exit 1 }
		if File.file?(file)
			PrintUtils.puts self.check_file(file, config) || 'Correct header'
		else
			FileFinder.explore_folder(file)
				.each do |source_file|
					message = self.check_file(source_file, config)
					if (message)
						PrintUtils.puts_single "#{source_file}"
						PrintUtils.puts(message, 1)
						PrintUtils.puts_single ''
					end
				end
		end
	end

	desc 'list-missing', 'Print a list of files missing (proper) header'
	def list_missing()
		dir = Dir.pwd
		config = self.load_config {|e| puts e.message; exit 1 }
		missing_headers = FileFinder.explore_folder(dir)
			.reject{|file| Core.has_header(file, config)}
		return PrintUtils.puts_single 'All files OK' if missing_headers.empty?
		PrintUtils.puts_single 'Files missing (proper) header:'
		PrintUtils.puts(missing_headers.map{|file| file.sub(dir + '/', '')}, 1)
	end

	desc 'delete [FILE|FOLDER]', 'Delete the header in FILE or to all files in FOLDER'
	def delete(file)
		config = self.load_config {|e| puts e.message; exit 1 }
		if File.file?(file)
			PrintUtils.puts_single "Deleting header in #{file}"
			Core.delete_header(file, config)
		else
			FileFinder.explore_folder(file)
				.each do |source_file|
					PrintUtils.puts_single "Deleting header in #{source_file}"
					Core.delete_header(source_file, config)
				end
		end
	end

	desc 'generate-license', 'Generate a LICENSE file containing a full license'
	def generate_license()
		config = self.load_config {|e| puts e.message; exit 1 }
		filename = 'LICENSE'
		if File.exists?(File.join(Dir.pwd, filename)) then
			PrintUtils.puts_single "There is already a #{filename} file. Abort generation."
		else
			full_license = IO.binread(Resources.get_full_license_path(config.license))
			File.write(filename, full_license % config.project_info)
			PrintUtils.puts_single "Created the #{filename} file (#{config.license})"
		end
	end

	map ['--version', '-v'] => :__print_version

	desc '--version, -v', 'Print version of xolti'
	def __print_version()
		puts XoltiVersion.get
	end

	map ['--license', '-l'] => :__print_license

	desc '--license, -l', 'Print licensing information of xolti'
	def __print_license()
		puts "Xolti version #{XoltiVersion.get}, Copyright (C) 2016 Rémi Even"
		puts 'Xolti comes with ABSOLUTELY NO WARRANTY.'
		puts 'This is free software, and you are welcome to redistribute it'
		puts 'under the terms of the GPLv3.'
		puts 'The complete license can be found at \'https://www.gnu.org/licenses/gpl.txt\'.'
		puts 'The source code of xolti can be found at \'https://github.com/RemiEven/xolti\'.'
	end

	no_commands {
		def ask_for_name(config)
			default_name = Pathname.getwd.basename.to_s
			print "name (#{default_name}): "
			typed_name = STDIN.gets.chomp
			config['project_info']['project_name'] = (typed_name == '') ? default_name : typed_name
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
			config['license'] = (typed_license == '') ? default_license : typed_license
		end

		def load_config()
			begin
				return XoltiConfig.load_config
			rescue Exception => e
				yield e if block_given?
			end
		end

		def check_file(file, config)
			diffs = Core.validate_header(file, config)
			if diffs.length > 0
				result = []
				diffs.each do |diff|
					if diff[:type] && diff[:type] == :no_header_found
						return ['No header found.']
					else
						result << "Line #{diff[:line_number]}: expected \"#{diff[:expected]}\" but got \"#{diff[:actual]}\"."
					end
				end
				return result.join("\n")
			end
		end
}

	desc 'init', 'Create xolti.yml'
	def init()
		config = self.load_config
		return PrintUtils.puts_single 'Xolti is already initialiazed' if config != nil
		PrintUtils.puts_single 'Initializing xolti project'
		config = {'project_info' => {}}
		self.ask_for_name(config)
		self.ask_for_author(config)
		self.ask_for_license(config)
		File.write('xolti.yml', config.to_yaml)
	end
end
