Dir['./lib/**/*.rb'].map { |f| p(f);require f }

require 'mocha'