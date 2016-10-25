Installation
============

Xolti being available on `RubyGems.org`_ makes it fairly easy to be installed :

.. code-block:: bash

    gem install xolti

Once the installation completes, ``xolti`` is added to your ``$PATH``, so you can access it from everywhere.

Requirements
------------

In order to properly work, Xolti requires Ruby to be installed. It has been tested with Ruby >= 2.1, but probably works with slightly older versions too.
In addition, and as stated in its GemFile, Xolti requires Thor, a ruby gem used to easily create command line interfaces.

Building from sources
---------------------

You can also create the gem from the source files, using the following commands (assuming you are in the project root):

.. code-block:: bash

    gem build xolti.gemspec

You can then install it with :

.. code-block:: bash

    gem install xolti-[VERSION].gem

where [VERSION] must be replaced by the current version of Xolti.

Running the tests
~~~~~~~~~~~~~~~~~

Running the tests requires the gem ``test-unit``, and can be achieved with the command :

.. code-block:: bash

    ruby test/ts_suite.rb

Alternatively, if you have installed ``rake`` in addition to ``test-unit``, you can use the command :

.. code-block:: bash

	rake test

.. _`RubyGems.org`:     https://rubygems.org/gems/xolti
