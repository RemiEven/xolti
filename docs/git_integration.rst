Git integration
===============

By default, xolti uses git as a datasource when completing a header template. This allows to easily retrieve all authors of a file, and all years in which a file has been modified, by leveraging git ``blame`` command.

Disabling git integration
-------------------------

To disable git integration and instead solely rely on what is in the ``xolti.yml`` file, you must add the following to it :

.. code-block:: yaml

  use_git: false
