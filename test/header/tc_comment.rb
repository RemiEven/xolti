# tc_comment.rb
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

require_relative '../../lib/header/comment'

class TestComment < Test::Unit::TestCase

	def test_simple_comment
		assert_equal("", Comment.comment("", "# "))
		assert_equal("# A\n", Comment.comment("A\n", "# "))
		assert_equal("# A\n# B\n", Comment.comment("A\nB\n", "# "))
		assert_equal("#\n", Comment.comment("\n", "# "))
	end

	def test_complex_comment
		assert_equal("/*\n */\n", Comment.comment("", ["/*", " * ", " */"]))
		assert_equal("/*\n * A\n */\n", Comment.comment("A\n", ["/*", " * ", " */"]))
		assert_equal("/*\n * A\n * B\n */\n", Comment.comment("A\nB\n", ["/*", " * ", " */"]))
		assert_equal("/*\n * A\n *\n */\n", Comment.comment("A\n\n", ["/*", " * ", " */"]))
	end
end
