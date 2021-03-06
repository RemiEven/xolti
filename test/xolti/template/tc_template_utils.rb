# tc_template_utils.rb
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

require 'xolti/template/template_utils'

class TestTemplateUtils < Test::Unit::TestCase
	def test_find_template_tokens_indexes
		assert_equal([], Xolti::TemplateUtils.find_template_tokens_indexes(''))
		assert_equal([], Xolti::TemplateUtils.find_template_tokens_indexes('ee'))
		assert_equal([2, 5], Xolti::TemplateUtils.find_template_tokens_indexes('ee%{r}'))
		assert_equal([2, 5, 7, 12], Xolti::TemplateUtils.find_template_tokens_indexes('ee%{r} %{abc}fe'))
	end

	def test_split_template_tokens_from_line
		assert_equal(['ee'], Xolti::TemplateUtils.split_template_tokens_from_line('ee'))
		assert_equal(['ee', '%{coucou}'], Xolti::TemplateUtils.split_template_tokens_from_line('ee%{coucou}'))
		assert_equal(['%{coucou}'], Xolti::TemplateUtils.split_template_tokens_from_line('%{coucou}'))
		assert_equal(['ee', '%{coucou}', 'ee'], Xolti::TemplateUtils.split_template_tokens_from_line('ee%{coucou}ee'))
		assert_equal(
			['ee', '%{coucou}', 'ee', '%{coucou}'],
			Xolti::TemplateUtils.split_template_tokens_from_line('ee%{coucou}ee%{coucou}')
		)
		assert_equal(
			['ee', '%{coucou}', '%{coucou}'],
			Xolti::TemplateUtils.split_template_tokens_from_line('ee%{coucou}%{coucou}')
		)
	end

	def test_create_detection_regexp_for_line
		assert_match(Xolti::TemplateUtils.create_detection_regexp_for_line('e'), 'e')
		assert_match(Xolti::TemplateUtils.create_detection_regexp_for_line('.'), '.')
		assert_no_match(Xolti::TemplateUtils.create_detection_regexp_for_line('.'), 'a')
		assert_match(Xolti::TemplateUtils.create_detection_regexp_for_line('%{r}'), 'azer')
		assert_match(Xolti::TemplateUtils.create_detection_regexp_for_line(''), '')
		assert_match(Xolti::TemplateUtils.create_detection_regexp_for_line('a%{r}r'), 'azer')
		assert_no_match(Xolti::TemplateUtils.create_detection_regexp_for_line('z%{r}f'), 'azer')
	end

	def test_extract_tag_type
		assert_equal(Xolti::TemplateUtils.extract_tag_type('%{coucou}'), 'coucou')
	end

	def test_tag?
		assert(Xolti::TemplateUtils.tag?('%{coucou}'))
		refute(Xolti::TemplateUtils.tag?('blabla'))
	end
end
