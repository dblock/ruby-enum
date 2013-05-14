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

      def define(key, value)
        @hash ||= {}
        @hash[key] = self.new(key, value)
      end

      def const_missing(key)
        if @hash[key]
          @hash[key].value
        else
          raise Ruby::Enum::Errors::UninitializedConstantError.new({ :name => name, :key => key })
        end
      end

      def each(&block)
        @hash.each do |key, value|
          yield key, value
        end
      end

      def parse(s)
        s = s.to_s.upcase
        each do |key, value|
          if key.to_s.upcase == s
            return value.value
          end
        end
        nil
      end      

    end

  end
end