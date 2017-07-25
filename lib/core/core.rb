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

# Core module containing methods to add, validate or remove a header in a file
module Core
	# Add a header to a file according to a configuration
	#
	# @param [Pathname] path the path of the file where to add the header
	# @param [XoltiConfig] config the configuration to use to create the header
	def self.licensify(path, config)
		config = config.complete_config_for_file(path, true)
		header = HeaderGenerator.create_for(path, config)
		FileModification.insert_lines_with_offset(path, header, config.offset)
	end

	# Delete the header in a file if one can be detected
	#
	# @param [Pathname] path the path of the file where to delete the header
	# @param [XoltiConfig] config the configuration to use
	def self.delete_header(path, config)
		template = config.template
		ext = File.extname(path)
		detected = HeaderDetector.detect(path, template, config.get_comment(ext))
		FileModification.delete_lines(path, detected[:start], detected[:matched_lines].length) if detected
	end

	# Detect whether a file contains a header
	#
	# @param [Pathname] path the path of the file where to detect the header
	# @param [XoltiConfig] config the configuration to use
	# @return [Hash] information about the detected header, or nil if none was found
	def self.header?(path, config)
		template = config.template
		ext = File.extname(path)
		HeaderDetector.detect(path, template, config.get_comment(ext))
	end

	# Check that a file contains a header and that it is correct
	#
	# @param [Pathname] path the path of the file where to check the header
	# @param [XoltiConfig] config the configuration to use
	# @return [Array<Hash>] a potentially empty array of differences between expected and actual header in the file
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
