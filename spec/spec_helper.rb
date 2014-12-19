require 'rspec'

RSpec.configure do |rspec|
  rspec.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
