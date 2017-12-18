Xoltignore reference
====================

In the same fashion git uses ``.gitignore`` files to know which files to track or not, xolti uses ``.xoltignore`` files to detect which files needs a header or not.

You can create one ``.xoltignore`` in each directory of your project.

Syntax
------

``.xoltignore`` files are plain text files, using a sub-set of the syntax of ``.gitignore`` :

- Each line specifies a pattern used to ignore or not a path
- A line is ignored if it is blank or starts with ``#```
- Globing (use of ``*`` and/or ``**`` wildcards) is supported
- A pattern can be inverted by prefixing it with ``!``
- Pattern are read line by line, from top to bottom; lower rules override higher ones, and rules from a deeper folder override rules from higher folders
- A pattern ending with ``/`` matches only directories
- A pattern starting with ``/`` is only applied to the directory containing the ``.xoltignore``

Example : js project
--------------------

Folders/files structure :

.. code-block:: text

	|- Javascript_Project
    	|- app.js
    	|- package.json
    	|- node_modules
        	|- ...

Possible ``.xoltignore`` :

.. code-block:: text

	# Ignore files installed by npm
	node_modules

	# Ignore package.json
	package.json

Example : java maven project
----------------------------

Folders/files structure :

.. code-block:: text

	|- Java_Maven_Project
    	|- pom.xml
    	|- readme
    	|- src
        	|- main
                |- java
		            |- App.java

Possible ``.xoltignore`` :

.. code-block:: text

	# Ignore all files but pom.xml and java sources
	*
	!/pom.xml
	!**/
	!src/**/*.java
