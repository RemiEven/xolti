# template_utils.rb
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
require 'xolti/template/tag/template_tags'


module Xolti
	# Module with methods used to parse and render a template
	module TemplateUtils
		# Return the positions of every (alternating) % and } in template_line
		#
		# @param [String] template_line the line to parse
		# @return [Array<Integer>] the positions of every alternating % and } in template_line
		def self.find_template_tokens_indexes(template_line)
			indexes = []
			searched_char = '%'
			(0..template_line.length - 1).each do |i|
				if template_line[i].chr == searched_char
					indexes.push(i)
					searched_char = searched_char == '%' ? '}' : '%'
				end
			end
			indexes
		end

		# Split a template line to separate tags from raw text
		#
		# @param [String] template_line the line to parse
		# @return [Array<String>] the split tokens
		def self.split_template_tokens_from_line(template_line)
			tokens = []
			current_token_start = 0
			current_token_end = 0
			in_tag = false
			while current_token_end < template_line.length
				if !in_tag && template_line[current_token_end].chr == '%'
					if current_token_end != current_token_start
						tokens.push(template_line[current_token_start..(current_token_end - 1)])
					end
					current_token_start = current_token_end
					in_tag = true
				elsif in_tag && template_line[current_token_end].chr == '}'
					tokens.push(template_line[current_token_start..current_token_end])
					current_token_start = current_token_end + 1
					in_tag = false
				end
				current_token_end += 1
			end
			tokens.push(template_line[current_token_start..-1]) unless current_token_start == template_line.length
			tokens
		end

		# Create a Regexp matching String compliant with the template line
		#
		# @param [String] template_line the line to parse
		# @return [Regexp] a regexp matching String compliant with the template line
		def self.create_detection_regexp_for_line(template_line)
			tokens = split_template_tokens_from_line(template_line)
			regexp_tokens = tokens.map do |token|
				tag?(token) ? create_regexp_for_tag(token) : Regexp.escape(token)
			end
			Regexp.new("(#{regexp_tokens.join(')(')})")
		end

		# Check whether a token is a tag
		#
		# @param [String] token the token to test
		# @return [Boolean] whether the token is a tag
		def self.tag?(token)
			token[0] == '%'
		end

		# Extract the tag type from a tag
		# @example
		#   extract_tag_type("%{year}") #=> "year"
		#
		# @param [String] tag the tag we want to extract the type from
		# @return [String] the extracted tag name
		def self.extract_tag_type(tag)
			tag[2..-2]
		end

		# Create a regexp from a tag name
		#
		# @param [String] tag_name the name of the tag
		# @return [Regexp] the detection_regexp associated with the tag
		def self.create_regexp_for_tag(tag_name)
			Xolti::TemplateTags.get_tag(extract_tag_type(tag_name)).detection_regexp
		end
	end
end
