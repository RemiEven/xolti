# simple_tag.rb
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
class SimpleTag
	attr :tag_name

	def initialize(tag_name)
		@tag_name = tag_name
	end

	def tag_name()
		@tag_name
	end

	def detection_regexp()
		".*"
	end

	def create_from(project_info)
		project_info[@tag_name.to_sym]
	end
end
