# tc_path_rule.rb
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

require 'xolti/core/path_rule'

class TestPathRule < Test::Unit::TestCase
	def test_simple_name_include
		path_rule = Xolti::PathRule.new('/root', 'e')
		assert_equal(:include, path_rule.effect)
		assert(path_rule.file_match('/root/e'))
		assert_nil(path_rule.file_match('/root/eeee'))
		assert(path_rule.file_match('/root/dir/e'))
		assert(path_rule.folder_match('/root/e'))
		assert(path_rule.folder_match('/root/dir/e'))
	end

	def test_simple_name_root_include
		path_rule = Xolti::PathRule.new('/root', '/e')
		assert_equal(:include, path_rule.effect)
		assert(path_rule.file_match('/root/e'))
		assert_nil(path_rule.file_match('/root/dir/e'))
		assert(path_rule.folder_match('/root/e'))
		assert_nil(path_rule.folder_match('/root/dir/e'))
	end

	def test_simple_name_exclude
		path_rule = Xolti::PathRule.new('/root', '!e')
		assert_equal(:exclude, path_rule.effect)
		assert(path_rule.file_match('/root/e'))
	end

	def test_folder_only_pattern
		path_rule = Xolti::PathRule.new('/root', 'dir/')
		assert(path_rule.folder_match('/root/dir'))
		assert(path_rule.folder_match('/root/e/dir'))
		assert_nil(path_rule.file_match('/root/dir'))
		assert_nil(path_rule.file_match('/root/e/dir'))
	end

	def test_simple_globing
		path_rule = Xolti::PathRule.new('/root', 'a*b')
		assert(path_rule.file_match('/root/ab'))
		assert(path_rule.file_match('/root/aZZZZb'))
		assert(path_rule.file_match('/root/dir/aZZZZb'))
		assert(path_rule.folder_match('/root/ab'))
	end

	def test_double_globing
		path_rule = Xolti::PathRule.new('/root', 'dir/**/e')
		assert(path_rule.file_match('/root/dir/e'))
		assert(path_rule.file_match('/root/dir/dir2/dir3/e'))
		assert_nil(path_rule.file_match('/root/dire'))
	end
end
