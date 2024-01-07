# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'benchmark'
require 'ruby-enum'

##
# Test enum
class Color
  include Ruby::Enum
  include Ruby::Enum::Case

  define :RED, :red
  define :GREEN, :green
  define :BLUE, :blue
end

puts 'Running 1.000.000 normal case statements'
case_statement_time = Benchmark.realtime do
  1_000_000.times do
    case Color::RED
    when Color::RED, Color::GREEN
      'red or green'
    when Color::BLUE
      'blue'
    end
  end
end

puts 'Running 1.000.000 ruby-enum case statements'
ruby_enum_time = Benchmark.realtime do
  1_000_000.times do
    Color.case(Color::RED,
               {
                 [Color::RED, Color::GREEN] => -> { 'red or green' },
                 Color::BLUE => -> { 'blue' }
               })
  end
end

puts "ruby-enum case: #{ruby_enum_time.round(4)}"
puts "case statement: #{case_statement_time.round(4)}"

puts "ruby-enum case is #{(ruby_enum_time / case_statement_time).round(2)} times slower"
