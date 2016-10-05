# header_generator.rb
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
require_relative "comment"

def complete_template(path, info, template)
	template %= info.merge({file_name: File.basename(path)})
	template
end

module HeaderGenerator
	def HeaderGenerator.create_for(path, config)
		bare_header = complete_template(path, config.project_info, config.template)
		Comment.comment(bare_header, config.get_comment(File.extname(path)))
	end
end
