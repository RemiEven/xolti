# tc_author_tag.rb
# Copyright (C) Rémi Even 2017
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

require 'xolti/template/tag/author_tag'

class TestAuthorTag < Test::Unit::TestCase
	def test_detection_regexp
		detection_regexp = Xolti::AuthorTag.new.detection_regexp
		assert_not_nil('Rémi Even'.match(detection_regexp))
		assert_not_nil('Rémi, Even'.match(detection_regexp))
		assert_nil(''.match(detection_regexp))
	end

	def test_create_from
		tag = Xolti::AuthorTag.new
		assert_equal('Rémi Even', tag.create_from(author: ['Rémi Even']))
		assert_equal('Rémi, Even', tag.create_from(author: %w[Rémi Even]))
	end
end
