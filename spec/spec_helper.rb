Dir['./lib/**/*.rb'].map { |f| require f }

require 'mocha'

RSpec.configure do |config|
  config.mock_with :mocha
end