# tc_header_validator.rb
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
require 'test/unit'

require 'xolti/header/header_validator'

class TestHeaderValidator < Test::Unit::TestCase
	def test_diff
		detected = {
			start: 2,
			matched_lines: [
				'# awesme.txt',
				'# ',
				'# (C) 207 Rémi E',
				'# Project Xolti'
			]
		}
		expected = [
			'# awesome.txt',
			'# ',
			'# (C) 2017 Rémi Even',
			'# Project Xolti'
		]
		diff = HeaderValidator.diff(expected.join("\n"), detected)
		assert_equal(2, diff.length)
		assert_equal({ line_number: 3, expected: expected[0], actual: detected[:matched_lines][0] }, diff[0])
		assert_equal({ line_number: 5, expected: expected[2], actual: detected[:matched_lines][2] }, diff[1])
	end
end
