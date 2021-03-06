# config.rb
# Copyright (C) Rémi Even 2016-2018
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

require 'xolti/core/default_comment_tokens'
require 'xolti/core/resources'
require 'xolti/core/config_value_retriever'


module Xolti
	# Class providing configuration data to other classes/modules
	#
	# @attr_reader [Hash] project_info information used to complete a header template
	# @attr_reader [String] template optional custom header template
	# @attr_reader [Integer] offset optional offset of lines between file start and header start
	# @attr_reader [String] license optional license name
	# @attr_reader [Boolean] use_git whether to use git as a datasource. Defaults to true
	# @attr_reader [Pathname] project_root the root path of the project
	class Config
		# Search for a xolti.yml file
		#
		# @param [Pathname] path the path where to start the search
		# @return [Pathname] path of the xolti.yml file
		def self.find_config_file(path = Pathname.getwd)
			potential_config_file = (path + 'xolti.yml')
			return potential_config_file if potential_config_file.file?
			raise 'No xolti.yml found' if path.root?
			find_config_file(path.parent)
		end

		# Create a configuration from the current workding directory
		#
		# @return [Xolti::Config] the created configuration
		def self.load_config
			config_file_path = find_config_file
			raw_config = YAML.safe_load(IO.binread(config_file_path.to_s))
			Xolti::Config.new(raw_config, config_file_path.dirname)
		end

		attr_reader :project_info, :template, :offset, :license, :use_git, :project_root

		# Initialize a Xolti Config from a raw config
		#
		# @param [Hash] raw_config the raw config
		# @param [String] project_root the root path of the project
		def initialize(raw_config, project_root)
			@project_info = raw_config['project']
			@comment = Xolti::DefaultComment::HASH.merge!(raw_config['comment'] || {})
			@license = raw_config['license']
			@template = Xolti::ConfigValueRetriever.new { raw_config['template'] }
				.or_try do
					default_template_path = Xolti::Resources.get_template_path(@license)
					IO.binread(default_template_path) if File.exist?(default_template_path)
				end
				.get
			@offset = Xolti::ConfigValueRetriever.new { raw_config['offset'] }
				.default(0)
			@use_git = Xolti::ConfigValueRetriever.new { raw_config['use_git'] }
				.default(true)
			@project_root = project_root
		end

		# Return the comment tokens applying to files with the given extension
		#
		# @param [String] ext the extension of the file
		# @return [Array<String>, String] an array of tokens if comment is complex, a single string otherwise
		def get_comment(ext)
			@comment[ext.delete('.')]
		end
	end
end
