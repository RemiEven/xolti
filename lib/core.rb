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

require_relative "file_modification"
require_relative "comment"
require_relative "header_detector"
require_relative "header_generator"

module Core
	def Core.licensify(path, config)
		header = HeaderGenerator.create_for(path, config)
		FileModification.insert_lines_with_offset(path, header, config.offset)
	end

	def Core.delete_header(path, config)
		template = config.template
		ext = File.extname(path)
		start = HeaderDetector.detect_position(path, template, config.get_comment(ext))
		FileModification.delete_lines(path, start, Comment.comment(template, config.get_comment(ext)).lines.length) if start >= 0
	end

	def Core.has_header(path, config)
		template = config.template
		HeaderDetector.detect_position(path, template, config.get_comment(File.extname(path))) >= 0
	end
end
