# author_tag.rb
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

# A tag for the author(s) of a file
class AuthorTag
	# The tag name
	TAG_NAME = 'author'.freeze

	# Return a regexp matching the content of the tag
	#
	# @return [String] a regexp matching the content of the tag
	def detection_regexp
		'.+'
	end

	# Create the value to use when replacing this tag in a template
	#
	# @param [Hash] project_info a Hash containing information from XoltiConfig
	# @return [String] the value to use when replacing this tag in a template
	def create_from(project_info)
		project_info[:author].join(', ')
	end
end
