# config_value_retriever.rb
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
	# Class allowing to easily retrieve a configuration value by trying new methods until one succeeds
	class ConfigValueRetriever
		# Create a new config value retriever
		#
		# @param [Block] block an optional block to define the first method to try
		def initialize(&block)
			@retrievers = block.nil? ? [] : [block]
		end

		# Add a new method to try if all previously defined ones have failed
		#
		# @param [Block] block a block to define the new method to try
		# @return [ConfigValueRetriever] self
		def or_try(&block)
			@retrievers << block
			self
		end

		# Try each defined method by definition order; if none succeeds, return the given default value
		#
		# @param default_value the default value to use
		# @return the value
		def default(default_value)
			or_try { default_value }
				.get
		end

		# Try each defined method by definition order; if none succeeds, return nil
		#
		# @return the value
		def get
			@retrievers.inject(nil) { |attribute, block| attribute.nil? ? block.call : attribute }
		end
	end
end
