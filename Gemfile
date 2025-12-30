# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

gem 'rake'

group :development, :test do
  gem 'danger'
  gem 'danger-changelog'
  gem 'danger-pr-comment'
  gem 'danger-toc'
  gem 'rspec'
  gem 'rubocop', '1.82.1'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
end

group :test do
  gem 'coveralls_reborn', require: false
end
