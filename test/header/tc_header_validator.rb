# tc_header_validator.rb
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
require "test/unit"

require_relative "../../lib/header/header_validator"

class TestHeaderValidator < Test::Unit::TestCase

	def test_diff
		actual_file_name = "awesme.txt"
		actual_year = "2017"
		actual_author = "Remi E"
		actual_project_name = "Xolti"
		detected = {
			start: 2,
			matches: [
				"# #{actual_file_name}".match(/^(# )(?<file_name>.*)$/),
				"# ".match(/^(# )$/),
				"# (C) #{actual_year} #{actual_author}".match(/^(# \(C\) )(?<year>[[:digit:]]{4})( )(?<author>.*)$/),
				"# Project #{actual_project_name}".match(/^(# Project )(?<project_name>.*)/)
			]
		}
		expected_file_name = "awesome.txt"
		expected_year = "2016"
		expected_author = "Rémi Even"
		expected_project_name = actual_project_name
		info = {
			file_name: expected_file_name,
			year: expected_year,
			author: expected_author,
			project_name: expected_project_name
		}
		diff = HeaderValidator.diff(detected, info)
		assert_equal(diff.length, 3)
		assert_equal(diff[0], {line: 3, expected: expected_file_name, actual: actual_file_name})
		assert_equal(diff[1], {line: 5, expected: expected_year, actual: actual_year})
		assert_equal(diff[2], {line: 5, expected: expected_author, actual: actual_author})
	end
end
