# path_rule.rb
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
class PathRule

	attr_reader :effect

	def initialize(path, pattern)
		if pattern.start_with?('!') then
			@effect = :exclude
			pattern = pattern[1..-1]
		else
			@effect = :include
		end
		@file_regexp = pattern_to_file_regexp(path, pattern)
		@folder_regexp = pattern_to_folder_regexp(path, pattern)
	end

	def file_match(path)
		@file_regexp =~ path
	end

	def folder_match(path)
		@folder_regexp =~ path
	end

	private def pattern_to_file_regexp(path, pattern)
		return nil if concern_only_folders(pattern)
		Regexp.new(glob_to_regexp(pattern).unshift(Regexp.escape(path)).join())
	end

	private def pattern_to_folder_regexp(path, pattern)
		pattern = pattern.chomp('/')
		prefix_detector_regexp = glob_to_regexp(pattern)
			.reverse()
			.reduce do |acc, s|
				"#{s}(#{acc})?"
			end
		Regexp.new(path + prefix_detector_regexp)
	end

	private def concern_only_folders(pattern)
		pattern.end_with?('/') || pattern.end_with?('**')
	end

	private def glob_to_regexp(pattern)
		pattern.split('/')
			.map do |e|
				if e == '**' then
					'(/.*)?'
				else
					Regexp.escape('/' + e).gsub('\\*', '[^/]*')
				end
			end
	end
end
