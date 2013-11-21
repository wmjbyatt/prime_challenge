require_relative 'helper'

class ComputedTableTest < MiniTest::Test
  def setup
    @prime_list_10 = PrimeList.new 10

    @prime_list_random_x = PrimeList.new Random.rand(100)
    @prime_list_random_y = PrimeList.new Random.rand(100)

    @block = lambda { |x, y| x * y }

    @table_10 = ComputedTable.new(@prime_list_10, @prime_list_10) { |x, y| @block.call x, y }
    @table_random = ComputedTable.new(@prime_list_random_x, @prime_list_random_y) { |x, y| @block.call x, y }

    @both_tables = [@table_10, @table_random]

  end

  def test_that_table_is_properly_dimensioned
    assert_equal @table_10.length, 11
    assert_equal @table_random.length, @prime_list_random_x.length + 1

    @table_random.each do |column|
      assert_equal column.length, @prime_list_random_y.length + 1
    end

    @table_10.each do |column|
      assert_equal column.length, 11
    end
  end

  def test_that_first_cell_is_blank
    @both_tables.each do |table|
      assert_nil table[0][0]
    end
  end

  def test_that_all_other_cells_are_populated
    @both_tables.each do |table|
      table.each_index do |x_index|
        table[x_index].each_index do |y_index|
          next if x_index == 0 && y_index == 0

          refute nil, table[x_index][y_index]
        end
      end
    end
  end

  def test_that_cells_calculated_correctly
    @both_tables.each do |table|

      prime_list = (table == @table_10 ? [@prime_list_10, @prime_list_10] : [@prime_list_random_x, @prime_list_random_y])

      table.each_index do |x_index|
        next if x_index == 0

        table[x_index].each_index do |y_index|
          next if y_index == 0

          assert_equal table[x_index][y_index], @block.call(prime_list.first[x_index-1], prime_list.last[y_index-1])
        end
      end
    end
  end

  def test_that_pretty_print_outputs_as_expected
    # Note: I'm not really sure how to get it to test that the output is FORMATTED correctly, although to be completely
    # fair, that's the point of the project, and that can be tested by running the core code.
    @both_tables.each do |table|
      assert_output(nil) { table.pretty_print }
    end
  end
end