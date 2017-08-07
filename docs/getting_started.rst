Getting started with a simple example
=====================================

Let's suppose you have a project, for example in NodeJS, with files organized like this :

.. code-block:: text

	|- myAwesomeProject
    	|- app.js
    	|- package.json
    	|- node_modules
        	|- ...

Now, how do you use Xolti to manage your license ?

Installation
------------

If not done already, this is the time to install Xolti. You can find detailed explanations in the
installation section of this documentation, but running this command is probably sufficient:

.. code-block:: bash

	gem install xolti

Initiating the project
----------------------

Then it's time to create the xolti configuration file, named ``xolti.yml``. This file will contain
information for Xolti such as the name of your project and the license you have chosen.

You can do this by running this command:

.. code-block:: bash

	xolti init

This will trigger a command line utility asking you some information, and will create a ``xolti.yml``
for your project based on what you answered.

.. code-block:: bash

	remi ~/myAwesomeProject]$ xolti init
	Initiating xolti project
	name (myAwesomeProject):
	author: Rémi Even
	license (GPL3.0):

Values between parenthesis will be selected if you do not type anything.

Creating a LICENSE file
-----------------------

Before adding license headers to your source file, you probably want to generate a ``LICENSE`` file,
which will be in the root of your project, and will contain the complete text of the license you have
chosen. To do so, use the following command :

.. code-block:: bash

	remi ~/myAwesomeProject]$ xolti generate-license
	Created the LICENSE file (GPL3.0)

Telling Xolti which files to modify (or not)
--------------------------------------------

Similarly to git and the ``.gitignore`` file, you can create a ``.xoltignore`` file to indicate
xolti files to ignore. The syntax is the same; for this project, the content of the xoltignore
would be :

.. code-block:: text

	node_modules
	package.json

.. tip::

	More details on ``.xoltignore`` files can be found :doc:`in the dedicated documentation page </xoltignore>`

Checking which files are missing headers
----------------------------------------

Now that xolti knows which files to handle, we can ask it which ones are missing headers.
We can either use the dedicated command:

.. code-block:: bash

	[22:14 remi ~/myAwesomeProject]$ xolti list-missing
	Files missing (proper) header:
	app.js

... or use ``xolti status``, which will report the files without correct headers.

.. code-block:: bash

	xolti status
	-- ./app.js
	No header found.

Adding the header to your files
-------------------------------

Looks like ``app.js`` is missing a header... Xolti can create and insert one for you, with the
``add`` command:

.. code-block:: bash

	xolti add app.js

.. tip::

	We could have also used ``.`` instead of specifying ``app.js``; xolti would have added a
	header in each file (recursively) from the current folder.

.. note::

	Xolti detects, based on its extension, that the ``app.js`` file contains Javascript.
	This allows Xolti to know how to create a comment in this file (in this case,
	with ``/*``, ``*`` and ``*/``).

Verifying the result
--------------------

Of course, you can verify that Xolti have actually added the header by simply opening the
file, but you can also use once again the ``status`` command:

.. code-block:: bash

	remi ~/myAwesomeProject]$ xolti status app.js
	Correct header.

That's it ! Your project is correctly licensed :).

Detecting incorrect headers
---------------------------

Now that we think of it, ``myAwesomeProject`` is not such a good name. ``myFantasticProject``
is way better ! To let xolti know of our change of mind, we can edit the ``xolti.yml`` file,
and replace the value of the key ``project_name`` by ``myFantasticProject``.

When we ask xolti once again about the status of the ``app.js`` file, it warns us about the now incorrect header:

.. code-block:: bash

	remi ~/myAwesomeProject]$ xolti status app.js
	Line 5: expected " * This file is part of myFantasticProject." but got " * This file is part of myAwesomeProject.".
	Line 7: expected " * myFantasticProject is free software: you can redistribute it and/or modify" but got " * myAwesomeProject is free software: you can redistribute it and/or modify".
	Line 12: expected " * myFantasticProject is distributed in the hope that it will be useful," but got " * myAwesomeProject is distributed in the hope that it will be useful,".
	Line 18: expected " * along with myFantasticProject. If not, see <http://www.gnu.org/licenses/>." but got " * along with myAwesomeProject. If not, see <http://www.gnu.org/licenses/>.".

You can then manually correct this outdated header.

Deleting the header in a file
-----------------------------

What if you decide that you no longer needs a header in your ``app.js`` ? Simply use the
``delete`` command:

.. code-block:: bash

	xolti delete app.js
