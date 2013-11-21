require_relative 'helper'

class PrimeListTest < MiniTest::Test
  def setup
    @primes_10 = PrimeList.new 10

    @random_length = Random.rand(100)
    @primes_rand = PrimeList.new @random_length


  end

  def test_that_instance_is_correct_length
    assert_equal @primes_10.length, 10
    assert_equal @primed_rand.length, @random_length
  end

  def test_that_is_prime_works
    require 'prime'

    candidates = (-100..100)
    candidates.each do |candidate|
      assert_equal PrimeList.is_prime?(candidate), Prime.prime?(candidate)
    end
  end
end