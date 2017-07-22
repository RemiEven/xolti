# tc_template_utils.rb
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

require_relative '../../../lib/header/tag/year_tag'

class TestYearTag < Test::Unit::TestCase

	def test_detection_regexp()
		detection_regexp = YearTag.new.detection_regexp
		assert_not_nil('2017'.match(detection_regexp))
		assert_not_nil('2017, 2077'.match(detection_regexp))
		assert_not_nil('2017-2077'.match(detection_regexp))
		assert_not_nil('1994, 1999-2002, 2017'.match(detection_regexp))
	end

	def test_create_from()
		tag = YearTag.new
		assert_equal('2017', tag.create_from({year: [2017]}))
		assert_equal('2017, 2077', tag.create_from({year: [2017, 2077]}))
		assert_equal('2017-2019', tag.create_from({year: [2017, 2018, 2019]}))
		assert_equal('1994-1996, 1998, 2000', tag.create_from({year: [1994, 1995, 1996, 1998, 2000]}))
	end
end
