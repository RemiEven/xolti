# tc_config.rb
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
require "test/unit"
require "mocha/test_unit"

require_relative "../../lib/core/config"
require_relative "../../lib/git/git_api"

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

	def test_use_git_true_by_default
		sut = XoltiConfig.new({
			"project_info" => {
				"project_name" => "Xolti",
				"author" => "Rémi Even"
			},
			"template" => "Header"
		})
		assert(sut.use_git)
	end

	def test_complete_config_no_git
		sut = XoltiConfig.new({
			"project_info" => {
				"project_name" => "Xolti",
				"author" => "Rémi Even"
			},
			"template" => "Header",
			"use_git" => false
		}).complete_config_for_file("/some/path/to/the/file.txt")
		refute(sut.use_git)
		assert_equal("file.txt", sut.project_info[:file_name])
	end

	def test_complete_config_use_git
		GitApi.expects(:modification_years_of).returns([1994])
		GitApi.expects(:authors_of).returns(["Rémi Even"])
		GitApi.expects(:user_name).returns(["Rémi Even"])

		sut = XoltiConfig.new({
			"project_info" => {
				"project_name" => "Xolti",
				"author" => "Rémi Even"
			},
			"template" => "Header"
		}).complete_config_for_file("/some/path/to/the/file.txt")
		assert_equal("file.txt", sut.project_info[:file_name])
		assert_equal([1994], sut.project_info[:year])
	end

	def test_complete_config_use_git_date_overriden
		GitApi.expects(:modification_years_of).returns([1994])
		GitApi.expects(:authors_of).returns(["Rémi Even"])
		GitApi.expects(:user_name).returns(["Rémi Even"])

		sut = XoltiConfig.new({
			"project_info" => {
				"project_name" => "Xolti",
				"author" => "Rémi Even",
				"year" => "2077"
			},
			"template" => "Header"
		})
		assert_not_equal([1994], sut.project_info[:year])
		sut = sut.complete_config_for_file("/some/path/to/the/file.txt")
		assert_equal([1994], sut.project_info[:year])
	end
end
