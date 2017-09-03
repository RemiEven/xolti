# proc_utils.rb
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
require 'open3'


module Xolti
	# Module providing a method to spawn an external process and capture its output
	module ProcUtils
		# Create an external process
		#
		# @param [String] command the command used to launch the process
		# @raise [SystemCallError] if the created process did not exited with success
		# @return [String] what the created process has written in its stdout
		def self.system(command)
			stdout, stderr, status = Open3.capture3(command)
			raise SystemCallError.new(stderr, status.exitstatus) unless status.success?
			stdout
		end
	end
end
