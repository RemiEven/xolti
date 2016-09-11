# tc_header_detection.rb
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

require_relative "../src/header_detection"

class TestHeaderDetection < Test::Unit::TestCase

	def test_find_template_tokens_indexes
		assert_equal([], HeaderDetection.find_template_tokens_indexes(""))
		assert_equal([], HeaderDetection.find_template_tokens_indexes("ee"))
		assert_equal([2, 5], HeaderDetection.find_template_tokens_indexes("ee%{r}"))
		assert_equal([2, 5, 7, 12], HeaderDetection.find_template_tokens_indexes("ee%{r} %{abc}fe"))
	end

	def test_split_template_tokens_from_line
		assert_equal(["ee"], HeaderDetection.split_template_tokens_from_line("ee"))
		assert_equal(["ee", "%{coucou}"], HeaderDetection.split_template_tokens_from_line("ee%{coucou}"))
		assert_equal(["%{coucou}"], HeaderDetection.split_template_tokens_from_line("%{coucou}"))
		assert_equal(["ee", "%{coucou}", "ee"], HeaderDetection.split_template_tokens_from_line("ee%{coucou}ee"))
		assert_equal(["ee", "%{coucou}", "ee", "%{coucou}"], HeaderDetection.split_template_tokens_from_line("ee%{coucou}ee%{coucou}"))
		assert_equal(["ee", "%{coucou}", "%{coucou}"], HeaderDetection.split_template_tokens_from_line("ee%{coucou}%{coucou}"))
	end

	def test_create_detection_regexp_for_line
		assert_match(HeaderDetection.create_detection_regexp_for_line("e"), "e")
		assert_match(HeaderDetection.create_detection_regexp_for_line("."), ".")
		assert_no_match(HeaderDetection.create_detection_regexp_for_line("."), "a")
		assert_match(HeaderDetection.create_detection_regexp_for_line("%{r}"), "azer")
		assert_match(HeaderDetection.create_detection_regexp_for_line(""), "")
		assert_match(HeaderDetection.create_detection_regexp_for_line("a%{r}r"), "azer")
		assert_no_match(HeaderDetection.create_detection_regexp_for_line("z%{r}f"), "azer")
	end

	def test_extract_tag_type
		assert_equal(HeaderDetection.extract_tag_type("%{coucou}"), "coucou")
	end

	def test_tag?
		assert(HeaderDetection.tag?("%{coucou}"))
		refute(HeaderDetection.tag?("blabla"))
	end
end
