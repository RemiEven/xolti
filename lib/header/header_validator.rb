# header_validator.rb
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Xolti. If not, see <http://www.gnu.org/licenses/>.
module HeaderValidator
	def HeaderValidator.diff(detected, info)
		diff = []
		detected[:matches].each_with_index do |match, i|
			line = detected[:start] + i + 1
			match.names.each do |name|
				name_sym = name.to_sym
				diff << {
					line: line,
					expected: info[name_sym],
					actual: match[name_sym]
				} if info[name_sym] != match[name_sym]
			end
		end
		diff
	end
end
