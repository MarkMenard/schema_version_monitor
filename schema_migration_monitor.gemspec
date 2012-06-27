# -*- encoding: utf-8 -*-
require File.expand_path('../lib/schema_migration_monitor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Enable Labs"]
  gem.email         = ["info@enablelabs.com"]
  gem.description   = %q{This gem is used to warn developers of pending schema migrations.}
  gem.summary       = %q{This gem is used to warn developers of pending schema migrations.}
  gem.homepage      = "https://github.com/EnableLabs/schema_version_monitor"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "schema_migration_monitor"
  gem.require_paths = ["lib"]
  gem.version       = SchemaMigrationMonitor::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency 'sqlite3'

  gem.add_dependency "activerecord"
end
