
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "administrate_exportable/version"

Gem::Specification.new do |spec|
  spec.name          = "administrate_exportable"
  spec.version       = AdministrateExportable::VERSION
  spec.authors       = ["Jônatas Rancan", "Andrei Bondarev"]
  spec.email         = ["hello@sourcelabs.io"]
  spec.homepage      = 'https://github.com/SourceLabsLLC/administrate_exportable'
  spec.summary       = "Simple plugin to add CSV export feature to Administrate"
  spec.description   = spec.summary
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'administrate','> 0.10.0'
  spec.add_dependency 'rails', '>= 4.2'
end
