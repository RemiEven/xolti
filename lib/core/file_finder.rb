# file_finder.rb
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

require_relative 'path_rule'

# Create an array of pathrules from a .xoltignore file if it exists
#
# @param [Pathname] path the folder where to search for the .xoltignore
# @return [Array<PathRule>] an array of PathRule created from the .xoltignore
def parse_xoltignore(path)
	xoltignore_path = "#{path}/.xoltignore"
	return [] unless File.file?(xoltignore_path)
	File.readlines(xoltignore_path)
		.reject { |line| line == '' || line[0] == '#' }
		.map(&:chomp)
		.map { |line| PathRule.new(path, line) }
end

# Module providing a method to recursively explore files and folders.
# Takes into account the encountered .xoltignore files
module FileFinder
	# Recursively explore a folder, taking into account .xoltignore files
	#
	# @param [String] folder the folder to explore
	# @param [Array<PathRule>] ignore_rules an array of PathRule describing which files/folders must be ignored
	# @return [Array<String>] an array with paths to all files not excluded by the .xoltignore
	def self.explore_folder(folder = Dir.pwd, ignore_rules = [])
		files = []
		ignored_paths = ['.', '..', '.git', '.xoltignore', 'xolti.yml', 'LICENSE']
		ignore_rules += parse_xoltignore(folder)

		Dir.glob("#{folder}/{*,.*}")
			.delete_if { |x| ignored_paths.include?(File.basename(x)) }
			.each do |path|
				# Do NOT ignore by default
				ignore = :exclude
				if File.directory?(path)
					ignore_rules.each do |rule|
						ignore = rule.effect if rule.folder_match(path)
					end
					files += explore_folder(path, ignore_rules) if ignore == :exclude
				else
					ignore_rules.each do |rule|
						ignore = rule.effect if rule.file_match(path)
					end
					files << path if ignore == :exclude
				end
			end
		files
	end
end
