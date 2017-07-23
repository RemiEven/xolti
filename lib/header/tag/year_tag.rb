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
class YearTag
	TAG_NAME = 'year'

	def detection_regexp
		'[[:digit:]]{4}(-[[:digit:]]{4})?(, [[:digit:]]{4}(-[[:digit:]]{4})?)*'
	end

	def create_from(project_info)
		years = project_info[:year]
		find_intervals(years)
			.map { |interval| format_year_interval(interval) }
			.join(', ')
	end

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

	private def format_year_interval(interval)
		return interval[0].to_s if interval[1] == interval[0]
		return "#{interval[0]}, #{interval[1]}" if interval[1] == interval[0] + 1
		"#{interval[0]}-#{interval[1]}"
	end
end
