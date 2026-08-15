# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'benchmark'
require 'ruby-enum'

##
# Base enum, no inheritance.
class Colors
  include Ruby::Enum

  define :RED, 'red'
  define :GREEN, 'green'
end

##
# Subclass, adds its own enum on top of an inherited one (1 level).
class SubColors < Colors
  define :BLUE, 'blue'
end

##
# Sub-subclass, adds its own enum on top of 2 inherited levels.
class SubSubColors < SubColors
  define :YELLOW, 'yellow'
end

n = 1_000_000

def benchmark(label, iterations, &block)
  time = Benchmark.realtime { iterations.times(&block) }
  puts "#{label}: #{time.round(4)}"
  time
end

puts "Running #{n} iterations of each scenario below\n\n"

puts '--- .value lookups, by depth of inheritance ---'
base_value = benchmark('base class (no inheritance)', n) { Colors.value(:RED) }
sub_value = benchmark('subclass (1 level)', n) { SubColors.value(:RED) }
sub_sub_value = benchmark('sub-subclass (2 levels)', n) { SubSubColors.value(:RED) }

puts "\n--- Other methods on a subclass (1 level) ---"
benchmark('.keys', n) { SubColors.keys }
benchmark('.key?', n) { SubColors.key?(:RED) }
benchmark('.to_h', n) { SubColors.to_h }
count = 0
benchmark('.each', n) { SubColors.each { |_k, _v| count += 1 } }

puts "\n--- Comparison ---"
puts "subclass value is #{(sub_value / base_value).round(2)}x base class value"
puts "sub-subclass value is #{(sub_sub_value / base_value).round(2)}x base class value"
