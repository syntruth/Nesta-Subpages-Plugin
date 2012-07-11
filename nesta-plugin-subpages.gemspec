# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nesta-plugin-subpages/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Syntruth"]
  gem.email         = ["syntruth@gmail.com"]
  gem.description   = "Plugin that adds index page subpages methods and helpers"
  gem.summary       = "Nesta CMS Subpages Plugin."
  gem.homepage      = "https://github.com/syntruth/Nesta-Subpages-Plugin"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nesta-plugin-subpages"
  gem.require_paths = ["lib"]
  gem.version       = Nesta::Plugin::Subpages::VERSION
  gem.add_dependency("nesta", ">= 0.9.11")
  gem.add_development_dependency("rake")
end
