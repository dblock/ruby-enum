# frozen_string_literal: true

module RubyEnum
  module Enum
    module Errors
      # Error raised when a duplicate enum key is found
      class DuplicateKeyError < Base
        def initialize(attrs)
          super(compose_message('duplicate_key', attrs))
        end
      end
    end
  end
end
