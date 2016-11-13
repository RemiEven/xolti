# tc_template_utils.rb
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
require "test/unit"

require_relative "../lib/template_utils"

class TestTemplateUtils < Test::Unit::TestCase

	def test_find_template_tokens_indexes
		assert_equal([], TemplateUtils.find_template_tokens_indexes(""))
		assert_equal([], TemplateUtils.find_template_tokens_indexes("ee"))
		assert_equal([2, 5], TemplateUtils.find_template_tokens_indexes("ee%{r}"))
		assert_equal([2, 5, 7, 12], TemplateUtils.find_template_tokens_indexes("ee%{r} %{abc}fe"))
	end

	def test_split_template_tokens_from_line
		assert_equal(["ee"], TemplateUtils.split_template_tokens_from_line("ee"))
		assert_equal(["ee", "%{coucou}"], TemplateUtils.split_template_tokens_from_line("ee%{coucou}"))
		assert_equal(["%{coucou}"], TemplateUtils.split_template_tokens_from_line("%{coucou}"))
		assert_equal(["ee", "%{coucou}", "ee"], TemplateUtils.split_template_tokens_from_line("ee%{coucou}ee"))
		assert_equal(["ee", "%{coucou}", "ee", "%{coucou}"], TemplateUtils.split_template_tokens_from_line("ee%{coucou}ee%{coucou}"))
		assert_equal(["ee", "%{coucou}", "%{coucou}"], TemplateUtils.split_template_tokens_from_line("ee%{coucou}%{coucou}"))
	end

	def test_create_detection_regexp_for_line
		assert_match(TemplateUtils.create_detection_regexp_for_line("e"), "e")
		assert_match(TemplateUtils.create_detection_regexp_for_line("."), ".")
		assert_no_match(TemplateUtils.create_detection_regexp_for_line("."), "a")
		assert_match(TemplateUtils.create_detection_regexp_for_line("%{r}"), "azer")
		assert_match(TemplateUtils.create_detection_regexp_for_line(""), "")
		assert_match(TemplateUtils.create_detection_regexp_for_line("a%{r}r"), "azer")
		assert_no_match(TemplateUtils.create_detection_regexp_for_line("z%{r}f"), "azer")
	end

	def test_extract_tag_type
		assert_equal(TemplateUtils.extract_tag_type("%{coucou}"), "coucou")
	end

	def test_tag?
		assert(TemplateUtils.tag?("%{coucou}"))
		refute(TemplateUtils.tag?("blabla"))
	end

	def test_find_intervals
		assert_equal(TemplateUtils.find_intervals([1, 2, 3]), [[1, 3]])
		assert_equal(TemplateUtils.find_intervals([1, 2, 3, 5, 6]), [[1, 3], [5, 6]])
		assert_equal(TemplateUtils.find_intervals([3, 1, 6, 2, 5]), [[1, 3], [5, 6]])
		assert_equal(TemplateUtils.find_intervals([1]), [[1, 1]])
		assert_equal(TemplateUtils.find_intervals([]), [])
		assert_equal(TemplateUtils.find_intervals([1, 7, 8]), [[1, 1], [7, 8]])
	end

	def test_format_year_interval
		assert_equal(TemplateUtils.format_year_interval([2016, 2016]), "2016")
		assert_equal(TemplateUtils.format_year_interval([2015, 2016]), "2015, 2016")
		assert_equal(TemplateUtils.format_year_interval([2014, 2016]), "2014-2016")
	end

	def test_create_year_list
		assert_equal("2016", TemplateUtils.year_list([2016]))
		assert_equal("2014, 2016", TemplateUtils.year_list([2016, 2014]))
		assert_equal("2014, 2015", TemplateUtils.year_list([2014, 2015]))
		assert_equal("2012, 2014-2016", TemplateUtils.year_list([2015, 2014, 2016, 2012]))
	end
end
