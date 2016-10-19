# xolti.rb
# Copyright (C) Rémi Even 2016
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Xolti. If not, see <http://www.gnu.org/licenses/>.

require "thor"
require "pathname"
require "yaml"

require_relative "core"
require_relative "config"
require_relative "file_finder"
require_relative "resources"
require_relative "version"

Signal.trap("INT") do
	puts "\nCancelling..."
	exit 1
end

class XoltiCLI < Thor

	desc "add [FILE|FOLDER]", "Add a header to FILE or to all files in FOLDER"
	def add(file)
		if File.file?(file)
			puts "Adding header to #{file}"
			config = self.load_config {|e| puts e.message; exit 1 }
			Core.licensify(file, config) if !Core.has_header(file, config)
		else
			config = self.load_config {|e| puts e.message; exit 1 }
			FileFinder.explore_folder(file)
				.reject{|source_file| Core.has_header(source_file, config)}
				.each do |source_file|
					puts "Adding header to #{source_file}"
					Core.licensify(source_file, config)
				end
		end
	end

	desc "check FILE", "Check the header of FILE"
	def check(file)
		config = self.load_config {|e| puts e; exit 1 }
		diffs = Core.validate_header(file, config)
		if diffs.length > 0
			diffs.each do |diff|
				if diff[:type] && diff[:type] == "no_header_found"
					puts "No header found."
				else
					puts "Line #{diff[:line]}: expected \"#{diff[:expected]}\" but got \"#{diff[:actual]}\"."
				end
			end
		else
			puts "Correct header."
		end
	end

	desc "list-missing", "Print a list of files missing (proper) header"
	def list_missing()
		dir = Dir.pwd
		config = self.load_config {|e| puts e.message; exit 1 }
		missing_headers = FileFinder.explore_folder(dir)
			.reject{|file| Core.has_header(file, config)}
		return puts "All files OK" if missing_headers.empty?
		puts "Files missing (proper) header:"
		missing_headers.each{|file| puts file[dir.length + 1..-1]}
	end

	desc "delete FILE", "Delete the header in FILE"
	def delete(file)
		puts "Deleting header in #{file}"
		config = self.load_config {|e| puts e.message; exit 1 }
		Core.delete_header(file, config)
	end

	desc "generate-license", "Generate a LICENSE file containing a full license"
	def generate_license()
		config = self.load_config {|e| puts e.message; exit 1 }
		filename = "LICENSE"
		if File.exists?(File.join(Dir.pwd, filename)) then
			puts "There is already a LICENSE file. Abort generation."
		else
			FileUtils.cp(Resources.get_full_license_path(config.license), filename)
			puts "Created the LICENSE file (#{config.license})"
		end
	end

	desc "status", "Check all files in current folder"
	def status()
		config = self.load_config {|e| puts e.message; exit 1 }
		FileFinder.explore_folder()
			.each do |source_file|
				puts "-- .#{source_file[Dir.pwd.length..-1]}"
				diffs = Core.validate_header(source_file, config)
				if diffs.length > 0
					diffs.each do |diff|
						if diff[:type] && diff[:type] == "no_header_found"
							puts "No header found."
						else
							puts "Line #{diff[:line]}: expected \"#{diff[:expected]}\" but got \"#{diff[:actual]}\"."
						end
					end
				else
					puts "Correct header."
				end
			end
	end

	map ["--version", "-v"] => :__print_version

	desc "--version, -v", "Print version of xolti"
	def __print_version()
		puts XoltiVersion.get
	end

	no_commands {
		def ask_for_name(config)
			default_name = Pathname.getwd.basename.to_s
			print "name (#{default_name}): "
			typed_name = STDIN.gets.chomp
			config["project_info"]["project_name"] = (typed_name == "") ? default_name : typed_name
		end

		def ask_for_author(config)
			print "author: "
			typed_author = STDIN.gets.chomp
			config["project_info"]["author"] = typed_author
		end

		def ask_for_license(config)
			default_license = "GPL3.0"
			print "license (#{default_license}): "
			typed_license = STDIN.gets.chomp
			config["license"] = (typed_license == "") ? default_license : typed_license
		end

		def load_config()
			begin
				return XoltiConfig.load_config
			rescue Exception => e
				yield e if block_given?
			end
		end
	}

	desc "init", "Create xolti.yml"
	def init()
		config = self.load_config
		return puts "Xolti is already initialiazed" if config != nil
		puts "Initiating xolti project"
		config = {"project_info" => {}}
		self.ask_for_name(config)
		self.ask_for_author(config)
		self.ask_for_license(config)
		File.write("xolti.yml", config.to_yaml)
	end
end
