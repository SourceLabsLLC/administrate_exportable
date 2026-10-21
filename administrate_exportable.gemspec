lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "administrate_exportable/version"

Gem::Specification.new do |spec|
  spec.name = "administrate_exportable"
  spec.version = AdministrateExportable::VERSION
  spec.authors = ["Jônatas Rancan", "Andrei Bondarev"]
  spec.email = ["hello@sourcelabs.io"]
  spec.homepage = "https://github.com/SourceLabsLLC/administrate_exportable"
  spec.summary = "Simple plugin to add CSV export feature to Administrate"
  spec.description = spec.summary
  spec.license = "MIT"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "administrate", ">= 0.17.0"
  spec.add_dependency "rails", ">= 4.2"
  spec.add_dependency "actionview", ">= 5.2.2.1"
  spec.add_dependency "railties", ">= 5.2.2.1"
  spec.add_dependency "csv", "~> 3.0"
end
