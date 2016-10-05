# default_comment_tokens.rb
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

class DefaultComment
	HASH = Hash.new(["/*", " * ", " */"]).merge!({
		"adb" => ["--", "-- ", "--"],
		"ads" => ["--", "-- ", "--"],
		"apt" => "~~ ",
		"asm" => [";", "; ", ";"],
		"asp" => ["<%", "' ", "%>"],
		"bas" => ["'", "' ", "'"],
		"bat" => "@REM",
		"cfc" => ["<!---", " ", "--->"],
		"cfm" => ["<!---", " ", "--->"],
		"cls" => "% ",
		"cmd" => "@REM",
		"dtd" => ["<!--", " ", "-->"],
		"e" => ["--", "-- ", "--"],
		"el" => ["!!!", "!!! ", "!!!"],
		"erl" => ["%%%", "%%% ", "%%%"],
		"f" => ["!", "! ", "!"],
		"fml" => ["<!--", " ", "-->"],
		"ftl" => ["<#--", " ", "-->"],
		"ftl" => ["<#--", " ", "-->"],
		"gsp" => ["<!--", " ", "-->"],
		"haml" => "-# ",
		"hrl" => ["%%%", "%%% ", "%%%"],
		"htm" => ["<!--", " ", "-->"],
		"html" => ["<!--", " ", "-->"],
		"jsp" => ["<%--", " ", "--%>"],
		"jspx" => ["<!--", " ", "-->"],
		"kml" => ["<!--", " ", "-->"],
		"lol" => ["OBTW", "", "TLDR"],
		"lua" => ["--[[", "", "]]"],
		"mxml" => ["<!--", " ", "-->"],
		"pas" => ["{*", " * ", " *}"],
		"pl" => "# ",
		"pm" => "# ",
		"pom" => ["<!--", " ", "-->"],
		"properties" => "# ",
		"py" => "# ",
		"rb" => "# ",
		"sh" => "# ",
		"sql" => ["--", "-- ", "--"],
		"sty" => "% ",
		"tex" => "% ",
		"tld" => ["<!--", " ", "-->"],
		"txt" => ["====", "\t", "===="],
		"vm" => ["#*", " ", "*#"],
		"xhtml" => ["<!--", " ", "-->"],
		"xml" => ["<!--", " ", "-->"],
		"xsd" => ["<!--", " ", "-->"],
		"xsl" => ["<!--", " ", "-->"],
		"yaml" => "# ",
		"yml" => "# "
	});
end
