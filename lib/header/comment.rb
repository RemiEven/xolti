# comment.rb
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

# Comment a text using simple comment token
#
# @param [String] text the text to comment
# @param [String] comment_token the simple comment token
# @return [String] the commented text
def simple_comment(text, comment_token)
	text.lines.map { |line| "#{comment_token}#{line}".rstrip + "\n" }.join
end

# Comment a text using complex comment tokens
#
# @param [String] text the text to comment
# @param [Array(String, String, String)] comment_tokens the complex comment tokens
# @return [String] the commented text
def complex_comment(text, comment_tokens)
	result = "#{comment_tokens[0]}\n"
	result << simple_comment(text, comment_tokens[1])
	result << "#{comment_tokens[2]}\n"
	result
end

# Module providing methods to comment texts
module Comment
	# Comment a text using simple or complex comment tokens
	#
	# @param [String] text the text to comment
	# @param [String, Array(String, String, String)] comment_tokens token to use to comment
	# @return [String] the commented text
	def self.comment(text, comment_tokens)
		comment_tokens.is_a?(String) ? simple_comment(text, comment_tokens) : complex_comment(text, comment_tokens)
	end
end
