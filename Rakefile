# frozen_string_literal: true

require 'rubygems'
require 'bundler/gem_tasks'

Bundler.setup :default, :development

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: %i[rubocop spec]

namespace :benchmark do
  desc 'Run benchmark for the Ruby::Enum::Case'
  task :case do
    require_relative 'benchmarks/case'
  end
end
