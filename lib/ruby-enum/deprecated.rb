# frozen_string_literal: true

# Deprecated backward-compatible alias for RubyEnum::Enum.
#
# Ruby 4.0 reserves the top-level `Ruby` module for the language itself, so
# this namespace is deprecated and will be removed in a future major version.
# Use RubyEnum::Enum instead.
module Ruby
  module Enum
    def self.included(base)
      warn '[DEPRECATION] `Ruby::Enum` is deprecated and will be removed in a future version. ' \
           'Use `RubyEnum::Enum` instead.'

      base.include RubyEnum::Enum
    end

    module Case
      def self.included(base)
        warn '[DEPRECATION] `Ruby::Enum::Case` is deprecated and will be removed in a future version. ' \
             'Use `RubyEnum::Enum::Case` instead.'

        base.include RubyEnum::Enum::Case
      end
    end

    Errors = RubyEnum::Enum::Errors
  end
end
