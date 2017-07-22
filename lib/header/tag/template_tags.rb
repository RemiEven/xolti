# template_tags.rb
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
require_relative 'year_tag'
require_relative 'simple_tag'

class TemplateTags
	COMPLEX_TAGS = [YearTag]
		.map{|tag_class| [tag_class::TAG_NAME, tag_class.new]}
		.to_h

	def TemplateTags.get_tag(tag_name)
		if self::COMPLEX_TAGS.has_key?(tag_name) then
			self::COMPLEX_TAGS[tag_name]
		else
			SimpleTag.new(tag_name)
		end
	end
end
