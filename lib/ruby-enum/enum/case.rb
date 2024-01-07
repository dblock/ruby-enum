# frozen_string_literal: true

module Ruby
  module Enum
    ##
    # Adds a method to an enum class that allows for exhaustive matching on a value.
    #
    # @example
    # class Color
    #   include Ruby::Enum
    #   include Ruby::Enum::Case
    #
    #   define :RED, :red
    #   define :GREEN, :green
    #   define :BLUE, :blue
    #   define :YELLOW, :yellow
    # end
    #
    # Color.case(Color::RED, {
    #   [Color::RED, Color::GREEN] => -> { "red or green" },
    #   Color::BLUE => -> { "blue" },
    #   Color::YELLOW => -> { "yellow" },
    # })
    #
    # Reserves the :else key for a default case:
    # Color.case(Color::RED, {
    #   [Color::RED, Color::GREEN] => -> { "red or green" },
    #   else: -> { "blue or yellow" },
    # })
    module Case
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      ##
      # @see Ruby::Enum::Case
      module ClassMethods
        class ValuesNotDefinedError < StandardError
        end

        class NotAllCasesHandledError < StandardError
        end

        def case(value, cases)
          validate_cases(cases)

          filtered_cases = cases.select do |values, _proc|
            values = [values] unless values.is_a?(Array)
            values.include?(value)
          end

          return call_proc(cases[:else], value) if filtered_cases.none?

          results = filtered_cases.map { |_values, proc| call_proc(proc, value) }

          # Return the first result if there is only one result
          results.size == 1 ? results.first : results
        end

        private

        def call_proc(proc, value)
          return if proc.nil?

          if proc.arity == 1
            proc.call(value)
          else
            proc.call
          end
        end

        def validate_cases(cases)
          all_values = cases.keys.flatten - [:else]
          else_defined = cases.key?(:else)
          superfluous_values = all_values - values
          missing_values = values - all_values

          raise ValuesNotDefinedError, "Value(s) not defined: #{superfluous_values.join(', ')}" if superfluous_values.any?
          raise NotAllCasesHandledError, "Not all cases handled: #{missing_values.join(', ')}" if missing_values.any? && !else_defined
        end
      end
    end
  end
end
