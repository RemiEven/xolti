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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Xolti. If not, see <http://www.gnu.org/licenses/>.
# TODO : handle "folder/file" patterns
def parse_xoltignore(path)
	xoltignorePath = "#{path}/.xoltignore"
	return [] if !File.file?(xoltignorePath)
	File.readlines(xoltignorePath).reject {|line| line == "" || line[0] == "#"}.map {|line| line.chomp}
end

module FileFinder
	def FileFinder.explore_folder(folder, ignoreRules=[])
		fileAcc = []
		ignoredPaths = [".", "..", ".git", ".xoltignore", "xolti.yml", "header.txt"]
		ignoreRules += parse_xoltignore(folder)

		Dir.glob("#{folder}/{*,.*}")
			.delete_if {|x| ignoredPaths.include?(File.basename(x))}
			.delete_if do |x|
				basename = File.basename(x)
				toIgnore = false
				ignoreRules.each do |rule|
					if (rule[0] == "!" && File.fnmatch(rule[1..-1], basename))
						toIgnore = false
					elsif (File.fnmatch(rule, basename))
						toIgnore = true
					end
				end
				toIgnore
			end
			.each do |path|
				if File.directory?(path)
					fileAcc += explore_folder(path, ignoreRules)
				else
					fileAcc << path
				end
			end

		fileAcc
	end
end
