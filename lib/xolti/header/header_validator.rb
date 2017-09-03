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
require 'xolti/header/header_generator'


module Xolti
	# Module with a method to detect differences between an actual and an expected header
	module HeaderValidator
		# Detectt differences between an actual and an expected header
		#
		# @param [String] expected the epxected header
		# @param [Hash{start: Integer, matched_lines: Array<String>}] detected the header detected by HeaderDetector
		# @return [Array<Hash{line_number: Integer, expected: String, actual: String}>] the detected differences
		def self.diff(expected, detected)
			diffs = expected.split("\n").map.with_index do |expected_line, i|
				{
					line_number: detected[:start] + i + 1,
					expected: expected_line,
					actual: detected[:matched_lines][i].chomp("\n")
				}
			end
			diffs.reject { |line_diff| line_diff[:expected] == line_diff[:actual] }
		end
	end
end
