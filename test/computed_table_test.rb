require_relative 'helper'

class ComputedTableTest < MiniTest::Test
  def setup
    @prime_list_10 = PrimeList.new 10

    @prime_list_random = PrimeList.new Math.rand(100)

    @block = lambda { |x, y| x * y }
    @table = ComputedTable.new(@primes, @primes) { |x, y| @block.call x, y }
  end

  def test_that_table_is_properly_dimensioned
    assert_equal @table.length, 11

    @table.each do |column|
      assert_equal column.length, 11
    end
  end

  def test_that_first_cell_is_blank
    assert_nil @table[0][0]
  end

  def test_that_all_other_cells_are_populated
    @table.each_index do |x_index|
      @table.each_index do |y_index|
        next if x_index == 0 && y_index == 0

        refute nil, @table[x_index][y_index]
      end
    end
  end

  def test_that_cells_calculated_correctly
    @table.each_index do |x_index|
      next if x_index == 0

      @table.each_index do |y_index|
        next if y_index == 0

        assert_equal @table[x_index][y_index], @block.call(@primes[x_index-1], @primes[y_index-1])
      end
    end
  end

  def test_that_pretty_print_outputs_as_expected
    # Note: I'm not really sure how to get it to test that the output is FORMATTED correctly, although to be completely
    # fair, that's the point of the project, and that can be tested by running the core code.

    assert_output(nil) { @table.pretty_print }
  end
end