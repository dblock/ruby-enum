module Ruby
  module Enum

    attr_reader :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      # Define an enumerated value.
      #
      # === Parameters
      # [key] Enumerator key.
      # [value] Enumerator value.
      def define(key, value)
        @_enum_hash ||= {}
        @_enum_hash[key] = self.new(key, value)
      end

      def const_missing(key)
        if @_enum_hash[key]
          @_enum_hash[key].value
        else
          raise Ruby::Enum::Errors::UninitializedConstantError.new({ :name => name, :key => key })
        end
      end

      # Iterate over all enumerated values.
      # Yields a key and an enumerated instance.
      def each(&block)
        @_enum_hash.each do |key, value|
          yield key, value
        end
      end

      # Map all enumerated values.
      # Yields a key and an enumerated instance.
      def map(&block)
        @_enum_hash.map do |key, value|
          yield key, value
        end
      end

      # Attempt to parse an enumerated value.
      #
      # === Parameters
      # [s] The string to parse.
      #
      # Returns an enumerated value or nil.
      def parse(s)
        s = s.to_s.upcase
        each do |key, enum|
          if key.to_s.upcase == s
            return enum.value
          end
        end
        nil
      end

      # Returns all enum keys.
      def keys
        @_enum_hash.values.map(&:key)
      end

      # Returns all enum values.
      def values
        @_enum_hash.values.map(&:value)
      end

      def to_h
        Hash[@_enum_hash.map do |key, enum|
          [ key, enum.value ]
        end]
      end

    end

  end
end
