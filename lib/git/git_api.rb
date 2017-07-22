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

module GitApi
	def GitApi.ignored_files()
		ProcUtils.system('git status --porcelain --ignored -z')
			.split('\u0000')
			.select { |line| line[0..1] == '!!' }
			.map { |line| line[3..-1] }
	end

	def GitApi.modified_files()
		ProcUtils.system('git status --porcelain -z')
			.split('\u0000')
			.select { |line| line[0..1] == '!!' }
			.map { |line| line[3..-1] }
	end

	def GitApi.user_name()
		ProcUtils.system('git config user.name').chomp
	end

	def GitApi.user_email()
		ProcUtils.system('git config user.email').chomp
	end

	def GitApi.authors_of(file, default_author = nil)
		ProcUtils.system("git blame #{file} -p")
			.split("\n")
			.select { |line| line.start_with? 'author ' }
			.map { |line| line[7..-1] }
			.map { |author| author == 'Not Committed Yet' ? default_author : author }
			.reject { |author| author == nil }
			.uniq
	end

	def GitApi.modification_years_of(file)
		ProcUtils.system("git blame #{file} -p")
			.split("\n")
			.select { |line| line.start_with? 'author-time' }
			.map { |line| line[11..-1] }
			.map { |epoch| Time.at(epoch.to_i).year }
			.uniq
	end
end
