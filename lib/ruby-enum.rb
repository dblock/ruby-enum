# frozen_string_literal: true

require 'ruby-enum/version'
require 'ruby-enum/enum'
require 'ruby-enum/enum/case'
require 'ruby-enum/enum/i18n_mock'

# Try to load the I18n gem and provide a mock if it is not available.
begin
  require 'i18n'
  Ruby::Enum.i18n = I18n
rescue LoadError
  # I18n is not available
  # :nocov:
  # Tests for this loading are in the spec_i18n folder
  Ruby::Enum.i18n = Ruby::Enum::I18nMock
  # :nocov:
end

Ruby::Enum.i18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales', 'en.yml')

require 'ruby-enum/errors/base'
require 'ruby-enum/errors/uninitialized_constant_error'
require 'ruby-enum/errors/duplicate_key_error'
require 'ruby-enum/errors/duplicate_value_error'
