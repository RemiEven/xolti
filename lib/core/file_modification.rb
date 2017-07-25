# file_modification.rb
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

# Module with methods to insert/delete lines from a text file
module FileModification
	# Insert a text in a text file
	#
	# @param [String] path the path to file to modify
	# @param [String] text the text to insert
	# @param [Integer] offset the offset between the start of the file and the place where to insert the test
	def self.insert_lines_with_offset(path, text, offset)
		file = Tempfile.new('xolti')
		begin
			File.open(path, 'r') do |source_file|
				i = 0
				source_file.each_line do |line|
					file.write(text) if i == offset
					i += 1
					file.write(line)
				end
			end
			file.close
			FileUtils.cp(file, path)
		ensure
			file.close
			file.unlink
		end
	end

	# Delete lines from a text file
	#
	# @param [String] path path to the file to modify
	# @param [Integer] start the number of the first line to delete
	# @param [Integer] length the number of lines to delete
	def self.delete_lines(path, start, length)
		file = Tempfile.new('xolti')
		begin
			File.open(path, 'r').each_with_index do |line, index|
				file.write(line) if index < start || index >= start + length
			end
			file.close
			FileUtils.cp(file, path)
		ensure
			file.close
			file.unlink
		end
	end
end
