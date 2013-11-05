class PrimeList
  include Enumerable
  #
  # Considered using streams or some other clever data structure, but I ultimately decided that a) they would reduce
  # readability and increase conceptual complexity and b) Ruby's native Array implementation is so much faster than
  # than a Ruby Stream implementation that I'd write that its increased theoretical algorithmic complexity for this
  # use case isn't really a deal.
  #
  # Also chose to not simply inherit from Array because I like the PrimeList.new(length) API and adding the method_missing
  # to delegate methods to @primes doesn't add notable conceptual complexity
  #
  # Further chose to build it all with simple trial division (versus some clever Sieve or something) to keep the code
  # compact enough to be obvious and because there don't appear to be any resource issues this way
  #

  def initialize length
    @primes = Array.new

    # First number whose primality we'll check
    candidate = 2

    while @primes.length < length
      @primes << candidate if candidate.is_prime?
      candidate += 1 # Frankly, we only need to test every other number (no odd except 3 is prime), but the special
                     # handling of 3 would obfuscate the code and the performance gains wouldn't be valuable.
    end
  end

  # Delegate method calls to @primes. This is simple enough to be acceptable.
  def method_missing method, *args, &block
    @primes.send method, *args, &block
  end

end

# Extend integer with Integer#is_prime?. This lets us keep PrimeList#iniitalize pretty neat and tidy and conceptually
# clear. Also would theoretically let us optimize a primality test without affecting PrimeList's code
class Integer
  def is_prime?
    # We're going to only look at positive values here. I don't believe it's correct to call negatives composite OR
    # prime, but we'll check em as though it is. This matches Prime's functionality.
    this = self.abs

    # Return a few simple base cases
    return false if this < 2
    return true if this == 2
    return false if this % 2 == 0

    # Build divisor list
    divisors = (2..Math.sqrt(this).ceil)

    # Aaaaaaand do trial division
    divisors.each do |divisor|
      return false if this % divisor == 0
    end

    return true
  end
end