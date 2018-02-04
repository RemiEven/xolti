# file_finder.rb
# Copyright (C) Rémi Even 2016-2018
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
require 'pathname'

require 'xolti/core/path_rule'

# Create an array of pathrules from a .xoltignore file if it exists
#
# @param [Pathname] path the folder where to search for the .xoltignore
# @return [Array<PathRule>] an array of PathRule created from the .xoltignore
def parse_xoltignore(path)
	xoltignore_path = path + '.xoltignore'
	return [] unless xoltignore_path.file?
	xoltignore_path.readlines
		.reject { |line| line == '' || line[0] == '#' }
		.map(&:chomp)
		.map { |line| Xolti::PathRule.new(path.to_s, line) }
end

# Create an array of default ignored path rules
#
# @param [Pathname] project_root the project root
# @param [Pathname] path the folder where to init the pathRules
# @return [Array<PathRule>] an array of PathRules
def init_ignore_rules(project_root, path)
	ignore_rules = %w[jpg jpeg png]
		.map { |extension| "*.#{extension}" }
		.map { |line| Xolti::PathRule.new(path.to_s, line) }

	parent_path = path
	loop do
		ignore_rules += parse_xoltignore(parent_path)
		break if parent_path == project_root || parent_path.root?
		parent_path = parent_path.parent
	end

	ignore_rules
end

module Xolti
	# Module providing a method to recursively explore files and folders.
	# Takes into account the encountered .xoltignore files, as well as those between the project root and the folder to
	# explore
	module FileFinder
		# Recursively explore a folder, taking into account .xoltignore files, as well as those between the project root and
		# the folder to explore
		#
		# @param [Pathname] project_root the project root
		# @param [Pathname] folder the folder to explore
		# @param [Array<PathRule>] ignore_rules an array of PathRule describing which files/folders must be ignored
		# @return [Array<String>] an array with paths to all files not excluded by the .xoltignore
		def self.explore_folder(
			project_root, folder = Pathname.getwd, ignore_rules = init_ignore_rules(project_root, folder.cleanpath)
		)
			files = []
			ignored_paths = ['.', '..', '.git', '.xoltignore', 'xolti.yml', 'LICENSE']
			ignore_rules += parse_xoltignore(folder)

			Dir.glob("#{folder.to_s.chomp('/')}/{*,.*}")
				.delete_if { |x| ignored_paths.include?(File.basename(x)) }
				.map { |path| Pathname.new(path) }
				.map(&:cleanpath)
				.each do |path|
					# Do NOT ignore by default
					ignore = :exclude
					if path.directory?
						ignore_rules.each do |rule|
							ignore = rule.effect if rule.folder_match(path.to_s)
						end
						files += explore_folder(project_root, path, ignore_rules) if ignore == :exclude
					else
						ignore_rules.each do |rule|
							ignore = rule.effect if rule.file_match(path.to_s)
						end
						files << path if ignore == :exclude
					end
				end
			files.map(&:to_s)
		end
	end
end
