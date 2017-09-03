# resources.rb
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

# Find directory containing the common resources.
# If xolti is not installed as a gem, assume that pwd is the root of the project
# Needed to fix travis integration.
#
# @return [String] the directory where xolti stores its common resources
def resource_dir
	if Gem::Specification.all_names.select { |name| name.match(/xolti/) }.length >= 1
		File.join(Gem::Specification.find_by_name('xolti').gem_dir, 'resources')
	else
		File.join(Dir.pwd, 'resources')
	end
end


module Xolti
	# A module to get the path of common resources such as header and full license templates
	module Resources
		# Create the path of the file containing the header for the given license.
		# Do not check whether the file actually exists.
		#
		# @param [String] license the wanted header license (eg "GPL3.0")
		# @return [String] the path of the file containing the header for the given license
		def self.get_template_path(license)
			File.join(resource_dir, 'headers', license)
		end

		# Create the path of the file containing the full template for the given license.
		# Do not check whether the file actually exists.
		#
		# @param [String] license the wanted full template license (eg "GPL3.0")
		# @return [String] the path of the file containing the full template for the given license
		def self.get_full_license_path(license)
			File.join(resource_dir, 'licenses', license)
		end
	end
end
