module Ruby
  module Enum
    attr_reader :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end

    def self.included(base)
      base.extend Enumerable
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
        @_enums_by_value ||= {}
        new_instance = new(key, value)
        @_enum_hash[key] = new_instance
        @_enums_by_value[value] = new_instance
        const_set key, value
      end

      # Iterate over all enumerated values.
      # Required for Enumerable mixin
      def each(&block)
        @_enum_hash.each(&block)
      end

      # Attempt to parse an enum key and return the
      # corresponding value.
      #
      # === Parameters
      # [k] The key string to parse.
      #
      # Returns the corresponding value or nil.
      def parse(k)
        k = k.to_s.upcase
        each do |key, enum|
          return enum.value if key.to_s.upcase == k
        end
        nil
      end

      # Whether the specified key exists in this enum.
      #
      # === Parameters
      # [k] The string key to check.
      #
      # Returns true if the key exists, false otherwise.
      def key?(k)
        @_enum_hash.key?(k)
      end

      # Gets the string value for the specified key.
      #
      # === Parameters
      # [k] The key symbol to get the value for.
      #
      # Returns the corresponding enum instance or nil.
      def value(k)
        enum = @_enum_hash[k]
        enum.value if enum
      end

      # Whether the specified value exists in this enum.
      #
      # === Parameters
      # [k] The string value to check.
      #
      # Returns true if the value exists, false otherwise.
      def value?(v)
        @_enums_by_value.key?(v)
      end

      # Gets the key symbol for the specified value.
      #
      # === Parameters
      # [v] The string value to parse.
      #
      # Returns the corresponding key symbol or nil.
      def key(v)
        enum = @_enums_by_value[v]
        enum.key if enum
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
          [key, enum.value]
        end]
      end
    end
  end
end
