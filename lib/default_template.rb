# default_template.rb
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
module DefaultTemplate

	# If xolti is not installed as a gem, assume that pwd is the root of the project
	# Needed to fix travis integration.
	Template_dir = Gem::Specification.all_names.select { |name| name.match(/xolti/) }.length >= 1 ?
		File.join(Gem::Specification.find_by_name("xolti").gem_dir, "templates") :
		File.join(Dir.pwd, "templates")

	def DefaultTemplate.read(license)
		IO.binread(File.join(Template_dir, license))
	end
end