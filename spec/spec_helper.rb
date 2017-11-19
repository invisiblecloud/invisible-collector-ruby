require 'simplecov'

SimpleCov.start

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(SimpleCov::Formatter::HTMLFormatter)

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "invoicecapture"
require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].each do |file|
  require file
end

RSpec.configure do |config|
  config.order = :random
  config.include RequestStubHelpers
end
