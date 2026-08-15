# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'benchmark'
require 'ruby-enum'

##
# Ruby::Enum equivalent of a plain Hash/constant lookup.
class Colors
  include Ruby::Enum

  define :RED, 'red'
  define :GREEN, 'green'
  define :BLUE, 'blue'
end

# Plain Ruby equivalents, doing the same lookups without Ruby::Enum.
PLAIN_HASH = { RED: 'red', GREEN: 'green', BLUE: 'blue' }.freeze

module PlainConstants
  RED = 'red'
  GREEN = 'green'
  BLUE = 'blue'
end

n = 1_000_000

def benchmark(label, iterations, &block)
  time = Benchmark.realtime { iterations.times(&block) }
  puts "#{label}: #{time.round(4)}"
  time
end

puts "Running #{n} iterations of each scenario below\n\n"

puts '--- Constant access ---'
enum_const_time = benchmark('Ruby::Enum constant (Colors::RED)', n) { Colors::RED }
plain_const_time = benchmark('plain Ruby constant (PlainConstants::RED)', n) { PlainConstants::RED }

puts "\n--- Key to value lookup ---"
enum_value_time = benchmark('Ruby::Enum (Colors.value(:RED))', n) { Colors.value(:RED) }
hash_value_time = benchmark('plain Hash (PLAIN_HASH[:RED])', n) { PLAIN_HASH[:RED] }

puts "\n--- Value to key lookup ---"
benchmark('Ruby::Enum (Colors.key(\'red\'))', n) { Colors.key('red') }
benchmark('plain Hash (PLAIN_HASH.key(\'red\'))', n) { PLAIN_HASH.key('red') }

puts "\n--- Existence checks ---"
benchmark('Ruby::Enum (Colors.key?(:RED))', n) { Colors.key?(:RED) }
benchmark('plain Hash (PLAIN_HASH.key?(:RED))', n) { PLAIN_HASH.key?(:RED) }

puts "\n--- Enumerating all keys/values ---"
benchmark('Ruby::Enum (Colors.keys)', n) { Colors.keys }
benchmark('plain Hash (PLAIN_HASH.keys)', n) { PLAIN_HASH.keys }
benchmark('Ruby::Enum (Colors.values)', n) { Colors.values }
benchmark('plain Hash (PLAIN_HASH.values)', n) { PLAIN_HASH.values }

puts "\n--- Comparison ---"
puts "Ruby::Enum constant access is #{(enum_const_time / plain_const_time).round(2)}x plain Ruby constant access"
puts "Ruby::Enum .value is #{(enum_value_time / hash_value_time).round(2)}x plain Hash#[]"
