# tc_config.rb
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

require_relative "../lib/config"

class TestConfig < Test::Unit::TestCase

	def test_default_comment
		sut = XoltiConfig.new({
			"project_info" => {
				"project_name" => "Xolti",
				"author" => "Rémi Even"
			},
			"template" => "Header",
			"comment" => {
				"tex" => "% "
			}
		})
		assert_equal(sut.get_comment("someUnknownExtension"), ["/*", " * ", " */"])
		assert_equal(sut.get_comment("rb"), "# ")
		assert_equal(sut.get_comment("tex"), "% ")
		assert_equal(sut.get_comment(".tex"), "% ")
	end
end
