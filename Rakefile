# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

namespace :style do
  desc 'Ruby style'
  RuboCop::RakeTask.new :ruby
end

RSpec::Core::RakeTask.new(:spec)

task default: %w[style:ruby spec]
