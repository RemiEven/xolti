lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xolti/core/version'

Gem::Specification.new do |spec|
	spec.name = 'xolti'
	spec.version = XoltiVersion.get
	spec.summary = 'A gem to manage license headers'
	spec.description = 'A gem to manage license headers, providing a simple CLI.'
	spec.authors = ['Rémi Even']
	spec.homepage = 'https://github.com/RemiEven/xolti'
	spec.license = 'GPL-3.0'
	spec.files = `git ls-files -z`.split("\x0")
	spec.bindir = 'exe'
	spec.executables << 'xolti'

	spec.add_runtime_dependency('thor', ['~>0.19.1', '>=0.19.1'])

	spec.add_development_dependency('mocha', ['~>1.2.1', '>= 1.2.1'])
	spec.add_development_dependency('rake', ['~>12.0.0', '>=12.0.0'])
	spec.add_development_dependency('test-unit', ['~>3.2.5', '>=3.2.5'])
	spec.add_development_dependency('yard', ['~>0.9.9', '>=0.9.9'])
	spec.add_development_dependency('rubocop', ['~>0.49.1', '>=0.49.1'])
end
