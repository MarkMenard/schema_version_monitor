# SchemaMigrationMonitor

This gem is used to warn developers of pending schema migrations.  Each time your development or test environment is loaded, a migration check will occur.  If a pending migration is found, the following example output will be in sent to your console output:


    ********************************************************
    ** The following migration(s) need to be run:         **
    **   - ./db/migrate/20120627151108_create_examples.rb **
    ********************************************************


## Installation

Add this line to your application's Gemfile:

    gem 'schema_migration_monitor', :group => [:development, :test]

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install schema_migration_monitor

## Usage

  Require the gem!

## Custom Migration Path

The gem uses the path './db/migrate' by default to find your migrations. If your project is using a custom path for migrations you must put a '.schema_migration_monitor.yml' in your project's root path. A sample '.schema_migration_monitor.yml' file would be written as follows:

    migration_path: './custom_migration_path'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
