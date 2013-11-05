require 'minitest/autorun'
load './lib/computed_table.rb'
load './lib/stream.rb'


primes =

prime_table = ComputedTable.new 10, 10, primes, primes { |x, y| x * y }