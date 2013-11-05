#require 'minitest/autorun'
load './lib/computed_table.rb'
load './lib/prime_list.rb'

def run!
  primes = PrimeList.new(ARGV[0] && ARGV[0].to_i || 10)
  table = ComputedTable.new(primes, primes) { |x, y| x * y }
  table.pretty_print
end

# Run if from the command-line. Making this separation will allow us to use this file's
# requires as the relevant bits in our tests.
run! if __FILE__ == $0