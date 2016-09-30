# config.rb
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
require "yaml"
require "pathname"

require_relative "default_comment"
require_relative "default_template"

def extract_project_info(raw_project_info)
	{
		author: raw_project_info["author"],
		project_name: raw_project_info["project_name"],
		year: raw_project_info["year"] || Date.today().year
	}
end

class XoltiConfig

	attr_reader :comment, :project_info, :template, :offset, :license

	def self.find_config_file(path = Pathname.getwd)
		potential_config_file = (path + "xolti.yml")
		return potential_config_file.to_s if potential_config_file.file?
		raise "No xolti.yml found" if path.root?
		find_config_file(path.parent)
	end

	def self.load_config()
		raw_config = YAML.load(IO.binread(find_config_file()))
		XoltiConfig.new(raw_config)
	end

	def initialize(raw_config)
		@project_info = extract_project_info(raw_config["project_info"])
		@comment = DefaultComment::HASH.merge!(raw_config["comment"] || {})
		@license = raw_config["license"]
		@template = raw_config.include?("template") ? raw_config["template"] : DefaultTemplate.read(self.license)
		@offset = raw_config["offset"] || 0
	end
end
