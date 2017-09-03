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


module Xolti
	# A rule created from a pattern read from a .xoltignore file, with method to know whether a path is compliant
	#
	# @attr_reader [Symbol] whether a file matching the rule must be :exclude(d) or :include(d)
	class PathRule
		attr_reader :effect

		# Constructor
		#
		# @param [String] path the path of the rule root folder
		# @param [Type] pattern the pattern of the rule
		def initialize(path, pattern)
			if pattern.start_with?('!')
				@effect = :exclude
				pattern = pattern[1..-1]
			else
				@effect = :include
			end
			@file_regexp = pattern_to_file_regexp(path, pattern)
			@folder_regexp = pattern_to_folder_regexp(path, pattern)
		end

		# Check if a file path matches the rule
		#
		# @param [String] path the path of the file
		# @return [MatchData] a MatchData if the file matches the rule, else nil
		def file_match(path)
			@file_regexp =~ path
		end

		# Check if a folder path matches the rule.
		# A folder path matches the rule if it may be a prefix of the rule pattern
		#
		# @param [String] path the path of the folder
		# @return [MatchData] a MatchData if the folder matches the rule, else nil
		def folder_match(path)
			@folder_regexp =~ path
		end

		# Create a regexp matching file paths complying to the rule
		#
		# @param [String] path the path of the rule root folder
		# @param [String] pattern the pattern of the rule
		# @return [Regexp] a regexp matching file paths complying to the rule
		private def pattern_to_file_regexp(path, pattern)
			return nil if concern_only_folders(pattern)
			Regexp.new(glob_to_regexp(pattern).unshift(Regexp.escape(path)).join)
		end

		# Create a regexp matching folder paths complying to the rule
		#
		# @param [String] path the path of the rule root folder
		# @param [String] pattern the pattern of the rule
		# @return [Regexp] a regexp matching folder paths complying to the rule
		private def pattern_to_folder_regexp(path, pattern)
			pattern = pattern.chomp('/')
			prefix_detector_regexp = glob_to_regexp(pattern)
				.reverse
				.reduce do |acc, s|
					"#{s}(#{acc})?"
				end
			Regexp.new(path + prefix_detector_regexp)
		end

		# Check whether a pattern matches only folders
		#
		# @param [String] pattern the pattern to check
		# @return [Boolean] whether the pattern matches only folders
		private def concern_only_folders(pattern)
			pattern.end_with?('/', '**')
		end

		# Transform a pattern with glob into a regexp
		#
		# @param [String] pattern the pattern to transform
		# @return [Regexp] a regexp created from the pattern
		private def glob_to_regexp(pattern)
			pattern.split('/')
				.map do |e|
					if e == '**'
						'(/.*)?'
					else
						Regexp.escape('/' + e).gsub('\\*', '[^/]*')
					end
				end
		end
	end
end
