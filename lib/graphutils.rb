# row, column accessor methods for 2-dimensonal array structures

# These methods are helper methods meant to make traversing 2d-Array structures much easier to manipulate. Keep in mind that the coordinate-techniques here are 0-indexed -- for example, the first item in a 2d array will have the coordinates of [0,0]. Another important thing to consider is that coordinate mapping with 2d array structures works differently than traditional xy_lookups. For easier comprehension, consider your x to refer to the row and your y to refer to the column, as such:

# [row, column]

# Included in these methods are enumerators that can perform iterations over entire N-d Array structures. We can call these 'deep' enumerators.

module GraphUtils

  def GraphUtils.find_rc(two_dimensional_array, target)
    column = nil
    row = nil
    two_dimensional_array.each do |y|
      if y.include?(target)
        row = two_dimensional_array.index(y)
        y.each do |x|
          if x == target
            column = y.index(x)
            break
          end
        end
      end
    end
    [row, column]
  end

  def GraphUtils.rc_lookup(two_dimensional_array, coordinates)
    row = coordinates[0]
    column = coordinates[1]
    two_dimensional_array[row][column]
  end

  def GraphUtils.find_column(board, column_index)
    column = []
    row_index = 0
    until row_index == board.length
      column << board[row_index][column_index]
      row_index += 1
    end
    column
  end

  def GraphUtils.surrounding_coordinates(two_dimensional_array, coordinates, options = {} )
    raise ArgumentError.new("Must include [row,column] coordinates") unless coordinates.is_a?(Array)
    range = options[:range] || :inclusive
    row = coordinates[0]
    column = coordinates[1]

    coordinates = [
      [(row - 1), (column    )], # up
      [(row - 1), (column - 1)], # upleft
      [(row    ), (column - 1)], # left
      [(row + 1), (column - 1)], # downleft
      [(row + 1), (column    )], # down
      [(row + 1), (column + 1)], # downright
      [(row    ), (column + 1)], # right
      [(row - 1), (column + 1)], # upright
      ]

      coordinates.unshift([row, column]) if range == :inclusive

      values = []
      coordinates.each do |xyvalues|
        unless xyvalues.any? { |n| n < 0 || n > two_dimensional_array.length-1 }
          values << xyvalues
        end
      end
      values
  end

  def GraphUtils.surrounding_coordinates_to_values(two_dimensional_array, coordinates, options = {})
    coordinates = GraphUtils.surrounding_coordinates(two_dimensional_array, coordinates, options)

    values = []
    coordinates.each do |xyvalues|
      unless xyvalues.any? { |n| n < 0 || n > two_dimensional_array.length-1 }
        values << rc_lookup(two_dimensional_array, xyvalues)
      end
    end
    values
  end

  def GraphUtils.deepmap!(array, &block)
    array.map! do |elem|
      elem.is_a?(Array) ? deepmap!(elem, &block) : yield(elem)
    end
  end

  def GraphUtils.deepmap(array, &block)
      array.map do |elem|
        elem.is_a?(Array) ? deepmap(elem, &block) : yield(elem)
    end
  end

  def GraphUtils.deepeach(array, &block)
      array.each do |elem|
        elem.is_a?(Array) ? deepeach(elem, &block) : yield(elem)
    end
  end

  def GraphUtils.deepselect!(array, &block)
      array.select! do |elem|
      elem.is_a?(Array) ? deepselect!(elem, &block) : yield(elem)
    end
    array
  end

end