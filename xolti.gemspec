Gem::Specification.new do |spec|
	spec.name = "xolti"
	spec.version = "0.0.0"
	spec.summary = "A gem to manage license headers"
	spec.description = "A gem to manage license headers"
	spec.authors = ["Rémi Even"]
	spec.homepage = "https://github.com/RemiEven/xolti"
	spec.license = "GPL-3.0"
	spec.files = `git ls-files -z`.split("\x0")
	spec.bindir = "exe"
	spec.executables << "xolti"

	spec.add_runtime_dependency("thor", ["~>0.19.1", ">=0.19.1"])
end
