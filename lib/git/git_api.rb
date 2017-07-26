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
require_relative 'proc_utils'

# This module provides methods used to access information stored by git,
# such as the authors of a file or the years it has been modified
module GitApi
	# Find files currently ignored by git
	#
	# @return [Array<String>] an Array containing paths of files currently ignored by git
	def self.ignored_files
		ProcUtils.system('git status --porcelain --ignored -z')
			.split('\u0000')
			.select { |line| line[0..1] == '!!' }
			.map { |line| line[3..-1] }
	end

	# Find files that has been modified since the last commit
	#
	# @return [Array<String>] an Array containing paths of files modified since the last commit
	def self.modified_files
		ProcUtils.system('git status --porcelain -z')
			.split('\u0000')
			.select { |line| line[0..1] == '!!' }
			.map { |line| line[3..-1] }
	end

	# Return the current git user name
	#
	# @return [String] the current git user name
	def self.user_name
		ProcUtils.system('git config user.name').chomp
	end

	# Return the current git user email
	#
	# @return [String] the current git user email
	def self.user_email
		ProcUtils.system('git config user.email').chomp
	end

	# Return every author of a file
	#
	# @param [String] file path to the file
	# @param [String] default_author optional default author if none is found
	# @return [Array<String>] an array with all authors of a file
	def self.authors_of(file, default_author = nil)
		ProcUtils.system("git blame #{file} -p")
			.split("\n")
			.select { |line| line.start_with? 'author ' }
			.map { |line| line[7..-1] }
			.map { |author| author == 'Not Committed Yet' ? default_author : author }
			.reject(&:nil?)
			.uniq
	end

	# Return every year a file has been modified
	#
	# @param [String] file path to the file
	# @return [Array<Integer>] an array with all years a file has been modified
	def self.modification_years_of(file)
		ProcUtils.system("git blame #{file} -p")
			.split("\n")
			.select { |line| line.start_with? 'author-time' }
			.map { |line| line[11..-1] }
			.map { |epoch| Time.at(epoch.to_i).year }
			.uniq
	end
end
