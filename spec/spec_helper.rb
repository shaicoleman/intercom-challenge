# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'awesome_print'
require 'byebug'
require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.warnings = true
  config.order = :random
  Kernel.srand config.seed
end
