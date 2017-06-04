# file_finder.rb
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Xolti. If not, see <http://www.gnu.org/licenses/>.
# TODO : handle "folder/file" patterns
def parse_xoltignore(path)
	xoltignore_path = "#{path}/.xoltignore"
	return [] if !File.file?(xoltignore_path)
	File.readlines(xoltignore_path).reject {|line| line == "" || line[0] == "#"}.map {|line| line.chomp}
end

module FileFinder
	def FileFinder.explore_folder(folder=Dir.pwd, ignore_rules=[])
		files = []
		ignored_paths = [".", "..", ".git", ".xoltignore", "xolti.yml", "LICENSE"]
		ignore_rules += parse_xoltignore(folder)

		Dir.glob("#{folder}/{*,.*}")
			.delete_if {|x| ignored_paths.include?(File.basename(x))}
			.delete_if do |x|
				basename = File.basename(x)
				to_ignore = false
				ignore_rules.each do |rule|
					if (rule[0] == "!" && File.fnmatch(rule[1..-1], basename))
						to_ignore = false
					elsif (File.fnmatch(rule, basename))
						to_ignore = true
					end
				end
				to_ignore
			end
			.each do |path|
				if File.directory?(path)
					files += explore_folder(path, ignore_rules)
				else
					files << path
				end
			end
		files
	end
end
