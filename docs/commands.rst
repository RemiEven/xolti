Commands
========

This part lists all commands provided by xolti.

add
---

.. code-block:: bash

	xolti add [FILE|FOLDER]

Add a header to ``FILE`` or to all non-ignored files in ``FOLDER``.

delete
------

.. code-block:: bash

	xolti delete [FILE|FOLDER]

Delete the header in ``FILE`` or to all non-ignored files in ``FOLDER``.

generate-license
----------------

.. code-block:: bash

	xolti generate-license

Generate a ``LICENSE`` file containing a full license, based on the one inside ``xolti.yml``.

help
----

.. code-block:: bash

	xolti help [COMMAND]

Describe available commands or one specific command.

init
----

.. code-block:: bash

	xolti init

Interactively create a ``xolti.yml`` file.

list
----

.. code-block:: bash

	xolti list-missing

Print a list of files missing (proper) header.

status
------

.. code-block:: bash

	xolti status [FILE|FOLDER]

Check the header of ``FILE`` or to all files in ``FOLDER``; ``FOLDER`` defaults to current working directory.

-l, --license
-------------

.. code-block:: bash

	xolti -l

Print licensing information of xolti.

-v, --version
-------------

.. code-block:: bash

	xolti -v

Print version of xolti.
