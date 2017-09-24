# git_api.rb
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
require 'xolti/git/proc_utils'


module Xolti
	# This module provides methods used to access information stored by git,
	# such as the authors of a file or the years it has been modified
	module GitApi
		# Check whether git blame can be called on a file
		#
		# @param [String] file the absolute path to the file to check
		# @return [Boolean] whether git blame can be called on a file
		def self.blameable?(file)
			@not_blameable_files ||= compute_not_blameable_files
			@not_blameable_files
				.select { |path| file.start_with?(path) }
				.empty?
		end

		# Get the files and folders upon which "git blame" cannot be used
		#
		# @return [Array<String>] the files and folders upon which "git blame" cannot be used
		def self.compute_not_blameable_files
			toplevel = Xolti::ProcUtils.system('git rev-parse --show-toplevel').chomp
			Xolti::ProcUtils.system('git status --porcelain --ignored -z')
				.split("\u0000")
				.reject { |line| ['!!', '??', 'A '].index(line[0..1]).nil? }
				.map { |line| File.join(toplevel, line[3..-1]) }
		end

		# Return the current git user name
		#
		# @return [String] the current git user name
		def self.user_name
			Xolti::ProcUtils.system('git config user.name').chomp
		end

		# Return every author of a file
		#
		# @param [String] file absolute path to the file
		# @return [Array<String>] an array with all authors of a file
		def self.authors_of(file)
			Xolti::ProcUtils.system("git blame #{file} -p")
				.split("\n")
				.select { |line| line.start_with? 'author ' }
				.map { |line| line[7..-1] }
				.reject { |author| author == 'Not Committed Yet' }
				.reject(&:nil?)
				.uniq
		end

		# Return every year a file has been modified
		#
		# @param [String] file absolute path to the file
		# @return [Array<Integer>] an array with all years a file has been modified
		def self.modification_years_of(file)
			Xolti::ProcUtils.system("git blame #{file} -p")
				.split("\n")
				.select { |line| line.start_with? 'author-time' }
				.map { |line| line[11..-1] }
				.map { |epoch| Time.at(epoch.to_i).year }
				.uniq
		end
	end
end
