# template_generator.rb
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
require 'xolti/template/comment'
require 'xolti/template/tag/template_tags'


module Xolti
	# Module with a method to generate a header for a file
	module TemplateGenerator
		# Create a header for a file
		#
		# @param [String] path the path to the file
		# @param [Xolti::Config] config the config to use to render the template
		# @param [Hash] header_data the data used to complete the header
		# @return [String] the generated (commented) header
		def self.create_header_for(path, config, header_data)
			formatted_header_data = header_data.map do |tag_name, _|
				[tag_name, Xolti::TemplateTags.get_tag(tag_name.to_s).create_from(header_data)]
			end.to_h
			bare_header = config.template % formatted_header_data
			Xolti::Comment.comment(bare_header, config.get_comment(File.extname(path)))
		end

		# Create a full license
		#
		# @param [Xolti::Config] config the config to use to render the template
		# @param [Hash] license_data the data used to complete the license
		# @return [String] the generated full license
		def self.create_full_license(config, license_data)
			formatted_license_data = license_data.map do |tag_name, _|
				[tag_name, Xolti::TemplateTags.get_tag(tag_name.to_s).create_from(license_data)]
			end.to_h
			license_template = IO.binread(Xolti::Resources.get_full_license_path(config.license))
			license_template % formatted_license_data
		end
	end
end
