# tc_config_value_retriever.rb
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

require 'xolti/core/config_value_retriever'

class TestConfig < Test::Unit::TestCase
	def test_nominal_case
		value = Xolti::ConfigValueRetriever.new { nil }
			.or_try { nil }
			.or_try { 2 }
			.get
		assert_equal(2, value)
	end

	def test_use_first_successful_value
		value = Xolti::ConfigValueRetriever.new { nil }
			.or_try { nil }
			.or_try { 2 }
			.or_try { 3 }
			.get
		assert_equal(2, value)
	end

	def test_no_block_in_initialize
		value = Xolti::ConfigValueRetriever.new
			.or_try { nil }
			.or_try { 2 }
			.get
		assert_equal(2, value)
	end

	def test_default_value
		value = Xolti::ConfigValueRetriever.new
			.or_try { nil }
			.default(2)
		assert_equal(2, value)
	end
end
