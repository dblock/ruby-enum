# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

gem 'rake'

group :development, :test do
  gem 'danger'
  gem 'danger-changelog'
  gem 'danger-toc'
  gem 'danger-pr-comment'
  gem 'rspec', '~> 3.0'
  gem 'rubocop', '~> 1.0'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
end

group :test do
  gem 'simplecov', require: false
end
