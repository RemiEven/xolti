# header_detector.rb
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
require_relative "template_utils"

module HeaderDetector
	def HeaderDetector.detect(path, template, comment_tokens)
		template_lines = Comment.comment(template, comment_tokens).lines("\n")
		template_regexp_lines = template_lines.map do |line|
			TemplateUtils.create_detection_regexp_for_line(line)
		end
		potential_header_start = 0
		matched_lines = []
		File.open(path, "r").each do |line|
			match = template_regexp_lines[matched_lines.length].match(line)
			if match
				matched_lines << line
				if matched_lines.length == template_regexp_lines.length
					return {
						start: potential_header_start,
						matched_lines: matched_lines
					}
				end
			else
				potential_header_start += matched_lines.length + 1
				matched_lines = []
			end
		end
		nil
	end
end
