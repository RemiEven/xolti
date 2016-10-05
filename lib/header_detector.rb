# header_detector.rb
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Xolti. If not, see <http://www.gnu.org/licenses/>.
require_relative "comment"
require_relative "template_utils"

module HeaderDetector
	def HeaderDetector.detect_position(path, template, comment_tokens)
		template_lines = Comment.comment(template, comment_tokens).lines("\n")
		template_regexp_lines = template_lines.map do |line|
			TemplateUtils.create_detection_regexp_for_line(line)
		end
		potential_header_start = 0
		i = 0
		File.open(path, "r").each do |line|
			if template_regexp_lines[i].match(line)
				i += 1
				return potential_header_start if i == template_regexp_lines.length
			else
				potential_header_start += i + 1
				i = 0
			end
		end
		-1
	end
end
