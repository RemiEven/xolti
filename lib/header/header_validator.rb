# header_validator.rb
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
require_relative 'header_generator'

module HeaderValidator
	def HeaderValidator.diff(expected, detected)
		expected.split("\n").map.with_index do |expected_line, i|
			{
				line_number: detected[:start] + i + 1,
				expected: expected_line,
				actual: detected[:matched_lines][i].chomp("\n")
			}
		end
		.reject { |line_diff| line_diff[:expected] == line_diff[:actual] }
	end
end
