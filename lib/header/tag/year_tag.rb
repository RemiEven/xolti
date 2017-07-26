# year_tag.rb
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

# A tag for the year(s) a file has been modified
class YearTag
	# The tag name
	TAG_NAME = 'year'

	# Reteurn a regexp matching the content of the tag
	#
	# @return [String] a regexp matching the content of the tag
	def detection_regexp
		'[[:digit:]]{4}(-[[:digit:]]{4})?(, [[:digit:]]{4}(-[[:digit:]]{4})?)*'
	end

	# Create the value to use when replacing this tag in a template
	#
	# @param [Hash] project_info a Hash containing information from XoltiConfig
	# @return [String] the value to use when replacing this tag in a template
	def create_from(project_info)
		years = project_info[:year]
		find_intervals(years)
			.map { |interval| format_year_interval(interval) }
			.join(', ')
	end

	# Detect intervals in a set of unordered numbers.
	# @example
	#   find_intervals([1, 5, 3, 2]) #=> [[1, 3], [5, 5]]
	#
	# @param [Array<Integer>] numbers the numbers where to detect the intervals
	# @return [Array<Array(Integer, Integer)>] description an array of detected interval
	private def find_intervals(numbers)
		sorted = numbers.sort
		intervals = []
		i = 0
		while i < sorted.size
			j = 1
			j += 1 while i + j < sorted.size && sorted[i + j] == sorted[i] + j
			intervals << [sorted[i], sorted[i + j - 1]]
			i += j
		end
		intervals
	end

	# Format an interval
	#
	# @example
	#   format_year_interval([1, 1]) #=> "1"
	# @example
	#   format_year_interval([1, 2]) #=> "1, 2"
	# @example
	#   format_year_interval([1, 3]) #=> "1-3"
	#
	# @param [Array(Integer, Integer)] interval the interval to format
	# @return [String] the formatted interval
	private def format_year_interval(interval)
		return interval[0].to_s if interval[1] == interval[0]
		return "#{interval[0]}, #{interval[1]}" if interval[1] == interval[0] + 1
		"#{interval[0]}-#{interval[1]}"
	end
end
