# header_data_retriever.rb
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

require_relative 'config'
require_relative 'config_value_retriever'

require_relative '../git/git_api'

# Module with a method to create header data
module HeaderDataRetriever
	# Retrieve a Hash with data necessary to complete a header template
	#
	# @param [String] file the file we want to create a header for
	# @param [XoltiConfig] config the config to use
	# @param [Boolean] include_current_year whether to include the current year
	def self.get_header_data_for(file, config, include_current_year = false)
		year = ConfigValueRetriever.new { Array(config.project_info['year']) if config.project_info['year'] }
			.or_try { GitApi.modification_years_of(file) if config.use_git }
			.default([Date.today.year])
		year = (year << Date.today.year).uniq if include_current_year

		author = ConfigValueRetriever.new { config.project_info['author'] }
			.or_try { GitApi.authors_of(file)[0] if config.use_git }
			.or_try { GitApi.user_name if config.use_git }
			.get

		project_name = ConfigValueRetriever.new { config.project_info['name'] }
			.get

		{
			file_name: File.basename(file),
			year: year,
			author: author,
			project_name: project_name
		}
	end
end
