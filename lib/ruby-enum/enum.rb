# frozen_string_literal: true

module Ruby
  module Enum
    class << self
      # Needed for I18n mock
      attr_accessor :i18n
    end

    attr_reader :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end

    def self.included(base)
      base.extend Enumerable
      base.extend ClassMethods

      base.private_class_method(:new)

      base.instance_variable_set(:@_own_enum_hash, {})
      base.instance_variable_set(:@_own_enums_by_value, {})
    end

    module ClassMethods
      # Define an enumerated value.
      #
      # === Parameters
      # [key] Enumerator key.
      # [value] Enumerator value.
      def define(key, value = key)
        validate_key!(key)
        validate_value!(value)

        store_new_instance(key, value)

        if upper?(key.to_s)
          const_set key, value
        else
          define_singleton_method(key) { value }
        end
      end

      def store_new_instance(key, value)
        new_instance = new(key, value)
        _own_enum_hash[key] = new_instance
        _own_enums_by_value[value] = new_instance

        # Invalidate memoized, merged hashes since this class' own enums changed.
        @_enum_hash = @_enums_by_value = nil
      end

      def const_missing(key)
        raise Ruby::Enum::Errors::UninitializedConstantError, name: name, key: key
      end

      # Iterate over all enumerated values, including those defined in a superclass.
      # Required for Enumerable mixin
      def each(&block)
        _enum_hash.each(&block)
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

      # Whether the specified key exists in this enum, including those defined in a superclass.
      #
      # === Parameters
      # [k] The string key to check.
      #
      # Returns true if the key exists, false otherwise.
      def key?(k)
        _enum_hash.key?(k)
      end

      # Gets the string value for the specified key, including those defined in a superclass.
      #
      # === Parameters
      # [k] The key symbol to get the value for.
      #
      # Returns the corresponding enum instance or nil.
      def value(k)
        enum = _enum_hash[k]
        enum&.value
      end

      # Whether the specified value exists in this enum, including those defined in a superclass.
      #
      # === Parameters
      # [k] The string value to check.
      #
      # Returns true if the value exists, false otherwise.
      def value?(v)
        _enums_by_value.key?(v)
      end

      # Gets the key symbol for the specified value, including those defined in a superclass.
      #
      # === Parameters
      # [v] The string value to parse.
      #
      # Returns the corresponding key symbol or nil.
      def key(v)
        enum = _enums_by_value[v]
        enum&.key
      end

      # Returns all enum keys, including those defined in a superclass.
      def keys
        _enum_hash.values.map(&:key)
      end

      # Returns all enum values, including those defined in a superclass.
      def values
        _enum_hash.values.map(&:value)
      end

      # Iterate over all enumerated values, including those defined in a superclass.
      # Required for Enumerable mixin
      def each_value(&_block)
        _enum_hash.each_value do |v|
          yield v.value
        end
      end

      # Iterate over all enumerated keys, including those defined in a superclass.
      # Required for Enumerable mixin
      def each_key(&_block)
        _enum_hash.each_value do |v|
          yield v.key
        end
      end

      # Returns a hash of key:values, including those defined in a superclass.
      def to_h
        _enum_hash.transform_values(&:value)
      end

      private

      # Returns this class' own enum hash, defaulting to an empty hash.
      #
      # A subclass that does not `define` any of its own enums does not have
      # its `@_own_enum_hash` instance variable set, since it's only initialized
      # in `define` and in the `included` hook.
      def _own_enum_hash
        @_own_enum_hash ||= {}
      end

      # Returns this class' own enums-by-value hash, defaulting to an empty hash.
      def _own_enums_by_value
        @_own_enums_by_value ||= {}
      end

      # Returns the enum hash for this class merged with all of its superclasses,
      # with keys defined in this class taking precedence over those inherited
      # from a superclass.
      def _enum_hash
        @_enum_hash ||= if superclass < Ruby::Enum
                          superclass.send(:_enum_hash).merge(_own_enum_hash)
                        else
                          _own_enum_hash
                        end
      end

      # Returns the enums-by-value hash for this class merged with all of its
      # superclasses, with values defined in this class taking precedence over
      # those inherited from a superclass.
      #
      # Derived from _enum_hash (keyed by key) rather than merged directly by
      # value, so that a superclass' stale value for a key overridden in this
      # class doesn't linger, e.g. when a subclass redefines a key with a new
      # value, the superclass' old value should no longer be found via value?
      # or key.
      def _enums_by_value
        @_enums_by_value ||= _enum_hash.each_with_object({}) do |(_key, enum), hash|
          hash[enum.value] = enum
        end
      end

      def upper?(s)
        !/[[:upper:]]/.match(s).nil?
      end

      def validate_key!(key)
        return unless _own_enum_hash.key?(key)

        raise Ruby::Enum::Errors::DuplicateKeyError, name: name, key: key
      end

      def validate_value!(value)
        return unless _own_enums_by_value.key?(value)

        raise Ruby::Enum::Errors::DuplicateValueError, name: name, value: value
      end
    end
  end
end
