# header_generator.rb
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
require_relative "comment"
require_relative "tag/template_tags"

module HeaderGenerator
	def HeaderGenerator.create_for(path, config)
		formatted_info = config.project_info.map { |tag_name, _|  [tag_name, TemplateTags.get_tag(tag_name.to_s).create_from(config.project_info)]}.to_h
		bare_header = config.template % formatted_info
		Comment.comment(bare_header, config.get_comment(File.extname(path)))
	end
end
