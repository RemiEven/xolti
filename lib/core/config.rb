# config.rb
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
require 'yaml'
require 'pathname'
require 'date'

require_relative 'default_comment_tokens'
require_relative 'resources'
require_relative 'config_value_retriever'

# Class providing configuration data to other classes/modules
#
# @attr_reader [Hash] project_info information used to complete a header template
# @attr_reader [String] template optional custom header template
# @attr_reader [Integer] offset optional offset of lines between file start and header start
# @attr_reader [String] license optional license name
# @attr_reader [String] use_git whether to use git as a datasource. Defaults to true
class XoltiConfig
	# Search for a xolti.yml file
	#
	# @param [Pathname] path the path where to start the search
	# @return [String] path of the xolti.yml file
	def self.find_config_file(path = Pathname.getwd)
		potential_config_file = (path + 'xolti.yml')
		return potential_config_file.to_s if potential_config_file.file?
		raise 'No xolti.yml found' if path.root?
		find_config_file(path.parent)
	end

	# Create a configuration from the current workding directory
	#
	# @return [XoltiConfig] the created configuration
	def self.load_config
		raw_config = YAML.safe_load(IO.binread(find_config_file))
		XoltiConfig.new(raw_config)
	end

	attr_reader :project_info, :template, :offset, :license, :use_git

	# Initialize a XoltiConfig from a raw config
	#
	# @param [Hash] raw_config the raw config
	def initialize(raw_config)
		@project_info = raw_config['project']
		@comment = DefaultComment::HASH.merge!(raw_config['comment'] || {})
		@license = raw_config['license']
		@template = ConfigValueRetriever.new { raw_config['template'] }
			.or_try do
				default_template_path = Resources.get_template_path(@license)
				IO.binread(default_template_path) if File.exist?(default_template_path)
			end
			.get
		@offset = ConfigValueRetriever.new { raw_config['offset'] }
			.default(0)
		@use_git = ConfigValueRetriever.new { raw_config['use_git'] }
			.default(true)
	end

	# Return the comment tokens applying to files with the given extension
	#
	# @param [String] ext the extension of the file
	# @return [Array<String>, String] an array of tokens if comment is complex, a single string otherwise
	def get_comment(ext)
		@comment[ext.delete('.')]
	end
end
