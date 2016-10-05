# core.rb
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
require "tempfile"

require_relative "template_utils"
require_relative "comment"
require_relative "resources"

def complete_template(path, info, template)
	template %= info.merge({file_name: File.basename(path)})
	template
end

def create_header_for(path, config)
	bare_header = complete_template(path, config.project_info, config.template)
	Comment.comment(bare_header, config.comment[get_ext(path)])
end

def insert_with_offset(path, text, offset)
	file = Tempfile.new("xolti")
	begin
		File.open(path, "r") do |source_file|
			i = 0
			source_file.each_line do |line|
				file.write(text) if i == offset
				i += 1
				file.write(line)
			end
		end
		file.close()
		FileUtils.cp(file, path)
	ensure
		file.close()
		file.unlink()
	end
end

def delete_lines_from_file(path, start, length)
	file = Tempfile.new("xolti")
	begin
		File.open(path, "r").each_with_index do |line, index|
			file.write(line) if index < start || index >= start + length
		end
		file.close()
		FileUtils.cp(file, path)
	ensure
		file.close()
		file.unlink()
	end
end

def detect_header_position(path, template, comment_tokens)
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

def get_ext(path)
	File.extname(path)[1..-1]
end

module Core
	def Core.licensify(path, config)
		header = create_header_for(path, config)
		insert_with_offset(path, header, config.offset)
	end

	def Core.delete_header(path, config)
		template = config.template
		ext = get_ext(path)
		start = detect_header_position(path, template, config.comment[ext])
		delete_lines_from_file(path, start, Comment.comment(template, config.comment[ext]).lines.length) if start >= 0
	end

	def Core.has_header(path, config)
		template = config.template
		detect_header_position(path, template, config.comment[get_ext(path)]) >= 0
	end
end
