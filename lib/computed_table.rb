class ComputedTable

  def initialize column_foundation, row_foundation, &cell_compute
    # Initalize table
    width = column_foundation.length
    height = row_foundation.length
    @table = Array.new(width+1) { Array.new(height+1)} # +1 accounts for empty cell in top-left
    @max_character_length = 1                          # Tracking for pretty-printing

    self.populate_column_headers column_foundation
    self.populate_row_headers row_foundation

    self.populate_cells cell_compute

  end

  # prints a table that looks like this:
  #
  #
  #    |   2    3    5    7   11   13   17   19   23
  # -------------------------------------------------
  #  2 |   4    6   10   14   22   26   34   38   46
  #  3 |   6    9   15   21   33   39   51   57   69
  #  5 |  10   15   25   35   55   65   85   95  115
  #  7 |  14   21   35   49   77   91  119  133  161
  # 11 |  22   33   55   77  121  143  187  209  253
  # 13 |  26   39   65   91  143  169  221  247  299
  # 17 |  34   51   85  119  187  221  289  323  391
  # 19 |  38   57   95  133  209  247  323  361  437
  # 23 |  46   69  115  161  253  299  391  437  529
  #
  def pretty_print
    @table.each_with_index do |column, x_index|
      column.each_with_index do |row, y_index|
        if row
          # Padding
          print ' '
          print ' ' * (@max_character_length - row.to_s.length)
          print row
          print ' '
        else
          print ' ' * (@max_character_length + 2)
        end

        print '|' if y_index == 0 # Handles separator after row header
      end

      print "\n"

      # Separator after column header
      if x_index == 0
        puts '-' * ((@max_character_length + 2) * @table.length)
      end
    end

  end

  # Delegate array methods to @table...
  def method_missing method, *args, &block
    if @table.respond_to? method
      @table.send method, *args, &block
    else
      super
    end
  end

  # ... and make respond_to? act correctly
  def respond_to?(sym, include_private = false)
    @table.respond_to?(sym) || super(sym, include_private)
  end

  protected

  def update_max_character_length compare_value
    if compare_value.to_s.length > @max_character_length
      @max_character_length = compare_value.to_s.length
    end
  end

  # Moving from left to right, we build each column header
  def populate_column_headers column_foundation
    width = column_foundation.length

    (1..width).each do |x_index|
      @table[x_index][0] = column_foundation[x_index-1]

      update_max_character_length @table[x_index][0] # See comment on this method call in #populate_row_headers
    end
  end

  # Moving from top to bottom, we build each row header
  def populate_row_headers row_foundation
    # stick a nil on the front of row_foundation and put that in @table[0]. Would normally just unshift this, but it
    # unshifts in place, modifying the array, which screws things up upstream. Oddly, row_foundation.dup.unshift wasn't
    # fixing it, which I don't understand.
    @table[0] = [nil, row_foundation].flatten

    # Run through and check each cell for character length. So far as this project's concerned, we happen to know that
    # the longest values are all going to be computed values (since we're multiplying integers), but that would be way
    # less fun to think about. Also, writing it that way would make pretty-printing this class fundamentally unusable
    # for a lot of other conceivable use cases.
    @table[0].each do |cell|
      update_max_character_length cell
    end
  end

  # Moving first down each column then to the next one, we populate the field values.
  #
  # If we wanted to be clever, we could do this with promises. We'd store lambdas at each cell and only execute them
  # when we actually accessed the cell. However, that would be gold plating for this project, since the only purpose
  # of this project is to print the table, and printing would require the execution of those lambdas. Plus that would
  # complicate the @max_character_length mechanism for pretty-printing.
  def populate_cells cell_compute
    @table.each_with_index do |column, x_index|
      # Skip headers
      next if x_index < 1

      column.each_index do |y_index|
        # Skip headers
        next if y_index < 1

        @table[x_index][y_index] = cell_compute.call(@table[x_index][0], @table[0][y_index])

        update_max_character_length @table[x_index][y_index]
      end
    end
  end

end