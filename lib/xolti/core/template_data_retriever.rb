# template_data_retriever.rb
# Copyright (C) Rémi Even 2017
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
require 'yaml'
require 'pathname'
require 'date'

require 'xolti/core/config'
require 'xolti/core/config_value_retriever'

require 'xolti/git/git_api'


module Xolti
	# Module with a method to create data to complete templates
	module TemplateDataRetriever
		# Retrieve a Hash with data necessary to complete a header template
		#
		# @param [String] file the file we want to create a header for
		# @param [Xolti::Config] config the config to use
		# @param [Boolean] include_current_year whether to include the current year
		# @return [Hash] the retrieved header data
		def self.get_header_data_for(file, config, include_current_year = false)
			year = Xolti::ConfigValueRetriever.new { Array(config.project_info['year']) if config.project_info['year'] }
				.or_try { Xolti::GitApi.modification_years_of(file) if config.use_git && Xolti::GitApi.blameable?(file) }
				.default([Date.today.year])
			year = (year << Date.today.year).uniq if include_current_year

			author = Xolti::ConfigValueRetriever.new { Array(config.project_info['author']) if config.project_info['author'] }
				.or_try { Xolti::GitApi.authors_of(file) if config.use_git && Xolti::GitApi.blameable?(file) }
				.or_try { Array(Xolti::GitApi.user_name) if config.use_git }
				.get

			project_name = Xolti::ConfigValueRetriever.new { config.project_info['name'] }
				.get
			{
				file_name: File.basename(file),
				year: year,
				author: author,
				project_name: project_name
			}
		end

		# Retrieve a Hash with data necessary to complete a license template
		#
		# @param [Xolti::Config] config the config to use
		# @return [Hash] the retrieved license data
		def self.get_license_data(config)
			year = Xolti::ConfigValueRetriever.new { Array(config.project_info['year']) if config.project_info['year'] }
				.default([Date.today.year])
			year = (year << Date.today.year).uniq

			author = Xolti::ConfigValueRetriever.new { Array(config.project_info['author']) if config.project_info['author'] }
				.or_try { Array(Xolti::GitApi.user_name) if config.use_git }
				.get

			project_name = Xolti::ConfigValueRetriever.new { config.project_info['name'] }
				.get
			{
				year: year,
				author: author,
				project_name: project_name
			}
		end
	end
end
