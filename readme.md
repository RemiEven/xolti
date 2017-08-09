# Xolti

> Tool assisting developers to manage license headers in source files, powered by Ruby.

[![Build Status](https://secure.travis-ci.org/RemiEven/xolti.svg?branch=master)](http://travis-ci.org/RemiEven/xolti)
[![Code Climate](https://codeclimate.com/github/RemiEven/xolti/badges/gpa.svg)](https://codeclimate.com/github/RemiEven/xolti)
[![Gem Version](https://badge.fury.io/rb/xolti.svg)](https://badge.fury.io/rb/xolti)
[![Documentation Status](http://readthedocs.org/projects/xolti/badge/?version=latest)](http://xolti.readthedocs.io/en/latest/)
[![License](https://img.shields.io/badge/license-GPL3-19c6ff.svg)](http://www.gnu.org/licenses/gpl-3.0.en.html)

## Purpose

If you ever had to manage the license of a project, you probably know how much a burden this task can become, especially if you try to keep it accurate !

Xolti is a piece of software aiming to assist the management of license-related information in a project. Its main functionality is to add and maintain license headers at the top of source files.

## Installation

Xolti is available on [RubyGems.org](https://rubygems.org/gems/xolti), so installing it is fairly easy:

```bash
gem install xolti
```

Once the installation completes, Xolti is added to your `$PATH`, so you can access it from everywhere.

> Please note that xolti is still in developer preview.

#### Requirements

Xolti requires Ruby to be installed in order to properly work. It has been tested with Ruby >= 2.1, but probably works with older versions too. In addition, Xolti requires `thor`, as stated in the `Gemfile`.

## Usage

Xolti provides a set of commands, including :

###### I want to add a header to a file named `awesome.txt` :

```
xolti add awesome.txt
```

###### I want to check that `awesome.txt` has a correct header :

```
xolti status awesome.txt
```

###### I want to get a list of all files missing correct headers :

```
xolti list_missing
```

## User documentation

Documentation is available [here](http://xolti.readthedocs.io/en/latest/).

## Development

#### Setup

- Check that Ruby is installed, then :

```bash
gem install bundle # make sure bundle is installed
git clone https://github.com/RemiEven/xolti.git
cd xolti
bundle install # install the dependencies
```

#### Running the tests

`rake test`

#### Lint

`rubocop`

#### Compiling documentation

`yard server`

#### Building the gem

`gem build xolti.gemspec`

## License

Xolti is a piece of free software licensed under the terms of the GNU-GPL3.
