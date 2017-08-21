xolti.yml
=========

``xolti.yml`` is a YAML file defining information used by Xolti, such as the name of your project and the license you have chosen. The easiest way to create one is by using ``xolti init`` at the root of your project.

Complete example
----------------

.. code-block:: yaml

  ---
  project_info:
    project_name: Xolti
    author: "Rémi Even"
    year: 2017
  license: GPL3.0
  offset: 2
  use_git: true
  comment:
    rb: '# '
    c:
      - '/*'
      - ' * '
      - ' */'
  template: |
    %{file_name}
    Copyright (C) %{author} %{year}

    This is a custom header for %{project_name}.

Supported configuration options are :

comment
-------

*Optional* Allow to extends/override default comment tokens. Comment tokens can either be simple (one token) or complex (start, middle and end token), and are grouped by the extension of the files where they must be used.

.. code-block:: yaml

  comment:
    rb: '# '
    c:
      - '/*'
      - ' * '
      - ' */'

The above piece of configuration overrides the default tokens for ``.rb`` and ``.c`` files.

license
-------

The license of your project. Mandatory if no custom ``template`` attribute is found, or if you want to use ``xolti license``. Supported values includes :

* AGPL-3.0
* Apache-2.0
* Beerware
* BSD-3-Clause
* GPL3.0
* LGPL-3.0
* MIT
* Unlicense
* WTFPL

.. code-block:: yaml

  license: GPL3.0

offset
------

*Optional* Allow you to define an offset of lines jump over when adding a header.

.. code-block:: yaml

  offset: 2

With the above piece of configuration, headers will be added at the third line of a file.

project_info
------------

YAML object containing data used to complete license header template.

.. code-block:: yaml

  project_info:
    project_name: Xolti
    author: "Rémi Even"
    year: 2017

author
^^^^^^

The author of your project.

project_name
^^^^^^^^^^^^

The name of your project.

year
^^^^

*Optional* The year your project has been written.

template
--------

*Optional* Allow you to use a custom header template.

.. code-block:: yaml

  template: |
    %{file_name}
    Copyright (C) %{author} %{year}

    This is a custom header for %{project_name}.

You can use the following tags in your headers :

- ``author``
- ``file_name``
- ``project_name``
- ``year``

use_git
-------

*Optional* Whether you allow xolti to use git as a datasource for completing the headers. Defaults to true.
