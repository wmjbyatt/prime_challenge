require_relative 'helper'

class PrimeListTest < MiniTest::Test
  def setup
    @primes = PrimeList.new 10
  end

  def test_that_instance_is_correct_length
    assert_equal @primes.length, 10
  end

  def test_that_is_prime_works
    require 'prime'

    candidates = (-100..100)
    candidates.each do |candidate|
      assert_equal candidate.is_prime?, Prime.prime?(candidate)
    end
  end
end