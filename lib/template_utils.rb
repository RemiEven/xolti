# template_utils.rb
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
module TemplateUtils

	# Return the positions of every (alternating) % and } in template_line
	def TemplateUtils.find_template_tokens_indexes(template_line)
		indexes = []
		searchedChar = "%"
		for i in 0..template_line.length - 1
			if template_line[i].chr == searchedChar
				indexes.push(i)
				searchedChar = searchedChar == "%" ? "}" : "%"
			end
		end
		indexes
	end

	def TemplateUtils.split_template_tokens_from_line(template_line)
		tokens = []
		currentTokenStart = 0
		currentTokenEnd = 0
		inTag = false
		while currentTokenEnd < template_line.length do
			if !inTag && template_line[currentTokenEnd].chr == "%"
				if (currentTokenEnd != currentTokenStart)
					tokens.push(template_line[currentTokenStart..(currentTokenEnd - 1)])
				end
				currentTokenStart = currentTokenEnd
				inTag = true
			elsif inTag && template_line[currentTokenEnd].chr == "}"
				tokens.push(template_line[currentTokenStart..currentTokenEnd])
				currentTokenStart = currentTokenEnd + 1
				inTag = false
			end
			currentTokenEnd += 1
		end
		tokens.push(template_line[currentTokenStart..-1]) unless currentTokenStart == template_line.length
		tokens
	end

	def TemplateUtils.create_detection_regexp_for_line(template_line)
		tokens = split_template_tokens_from_line(template_line)
		regexpTokens = tokens.map do |token|
			if tag?(token) then create_regexp_for_tag(token) else Regexp.escape(token) end
		end
		Regexp.new("(#{regexpTokens.join(")(")})")
	end

	def TemplateUtils.tag?(token)
		token[0] == "%"
	end

	def TemplateUtils.extract_tag_type(tag)
		tag[2..-2]
	end

	def TemplateUtils.create_regexp_for_tag(tag)
		case extract_tag_type(tag)
		when "year"
			"?<year>[[:digit:]]{4}"
		when "author"
			"?<author>.*"
		when "project_name"
			"?<project_name>.*"
		when "file_name"
			"?<file_name>.*"
		else
			".*"
		end
	end
end
