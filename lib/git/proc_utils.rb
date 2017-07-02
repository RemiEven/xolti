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
module ProcUtils
	def ProcUtils.fork_and_close(command, o)
		res = Kernel.system(command, :out => o, :err => o)
		o.close
		res
	end

	def ProcUtils.system(command)
		i, o = IO.pipe
		begin
			case fork_and_close(command, o)
			when true
				return i.read
			when false
				raise i.read
			else
				raise "fail"
			end
		ensure
			i.close
		end
	end
end
