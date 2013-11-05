class ComputedTable
  def initialize(width = 10, height = 10, row_foundation, column_foundation, &cell_compute)
    @table = Array.new(width+1) { Array.new(height+1)}
    @max_character_length # Will be used for pretty-printing the table

    (1..width).each do |x_index|
      @table[x_index][0] = column_foundation[x_index-1]

      update_max_chracter_length @table[x_index][0]
    end

    (1..height).each do |y_index|
      @table[0][y_index] = row_foundation[y_index-1]

      update_max_chracter_length @table[0][y_index]
    end

    @table.each_with_index do |column, x_index|
      next if x_index < 1

      column.each_with_index do |row, y_index|
        next if y_index < 1

        @table[x_index][y_index] = cell_compute.call(@table[x_index][0], @table[0][y_index])
      end
    end
  end

  protected

  def update_max_character_length(compare_value)
    if compare_value.to_s.length > @max_character_length
      @max_character_length = compare_value.to_s.length
    end
  end
end