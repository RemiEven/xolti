# core.rb
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
require 'tempfile'

require_relative 'file_modification'
require_relative '../header/header_detector'
require_relative '../header/header_generator'
require_relative '../header/header_validator'

module Core
	def self.licensify(path, config)
		config = config.complete_config_for_file(path, true)
		header = HeaderGenerator.create_for(path, config)
		FileModification.insert_lines_with_offset(path, header, config.offset)
	end

	def self.delete_header(path, config)
		template = config.template
		ext = File.extname(path)
		detected = HeaderDetector.detect(path, template, config.get_comment(ext))
		FileModification.delete_lines(path, detected[:start], detected[:matched_lines].length) if detected
	end

	def self.header?(path, config)
		template = config.template
		ext = File.extname(path)
		HeaderDetector.detect(path, template, config.get_comment(ext))
	end

	def self.validate_header(path, config)
		config = config.complete_config_for_file(path)
		template = config.template
		ext = File.extname(path)
		detected = HeaderDetector.detect(path, template, config.get_comment(ext))
		return [{ type: :no_header_found }] unless detected
		expected = HeaderGenerator.create_for(path, config)
		HeaderValidator.diff(expected, detected)
	end
end
