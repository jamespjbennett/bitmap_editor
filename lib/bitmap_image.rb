require 'pry'

class BitmapImage

  def initialize
    @rows = nil
    @columns = nil
    @grid = nil
  end

  def generate_grid(command)
    int_values = command_integer_values(command)
    return puts "Grid must be less than ot equal to 250 * 250" if int_values.max > 250
    @rows = int_values[1]
    @columns = int_values[0]
    create_clear_grid
  end

  def create_clear_grid
    @grid = Array.new(@rows) {Array.new(@columns) {'O'}}
  end

  def command_integer_values(command)
    command.scan(/\d+/).map(&:to_i)
  end

  def command_string_values(command)
    command.scan(/[a-zA-Z]/)
  end

  def within_bounds?(x_coordinates, y_coordinates)
    x_coordinates_valid = x_coordinates.map{|coordinate| coordinate + 1 <= @columns}.uniq == [true]
    y_coordinates_valid = y_coordinates.map{|coordinate| coordinate + 1 <= @rows}.uniq == [true]
    x_coordinates_valid && y_coordinates_valid
  end

  def display_grid
    @grid.each{|row| puts row.join(" ")}
  end

  def colour_single_pixel(command)
    int_values = command_integer_values(command)
    x_axis_coordinate = int_values[0] - 1
    y_axis_coordinate = int_values[1] - 1
    return puts "Coordinates out of bounds" if !within_bounds?([x_axis_coordinate], [y_axis_coordinate])
    colour = command_string_values(command).last
    @grid[y_axis_coordinate][x_axis_coordinate] = colour
  end

  def draw_vertical_line(command)
    int_values = command_integer_values(command)
    x_axis_coordinate = int_values[0] - 1
    y_axis_coordinate_1 = int_values[1] - 1
    y_axis_coordinate_2 = int_values[2] - 1
    return puts "Coordinates out of bounds" if !within_bounds?([x_axis_coordinate], [y_axis_coordinate_1, y_axis_coordinate_2])
    colour = command_string_values(command).last
    @grid[y_axis_coordinate_1..y_axis_coordinate_2].each{|row| row[x_axis_coordinate] = colour}
  end

  def draw_horizontal_line(command)
    int_values = command_integer_values(command)
    x_axis_coordinate_1 = int_values[0] - 1
    x_axis_coordinate_2 = int_values[1] - 1
    y_axis_coordinate = int_values[2] - 1
    return puts "Coordinates out of bounds" if !within_bounds?([x_axis_coordinate_1, x_axis_coordinate_2], [y_axis_coordinate])
    colour = command_string_values(command).last
    (x_axis_coordinate_1..x_axis_coordinate_2).to_a.each{|coordinate| @grid[y_axis_coordinate][coordinate] = colour}
  end

  def fill_colour(command)
    int_values = command_integer_values(command)
    x_axis_coordinate = int_values[0] - 1
    y_axis_coordinate = int_values[1] - 1
    colour = command_string_values(command).last
    @grid[y_axis_coordinate][x_axis_coordinate] = colour
    next_fill_colour_coordinate = fill_colour_with_empty_surrounding(colour)
    if next_fill_colour_coordinate
      binding.pry
    end
  end

  def fill_colour_with_empty_surrounding(colour)
    next_fill_coordinate_to_populate = nil
    @grid.each_with_index do |grid_row, grid_row_index|
      if grid_row.index(colour)
        horizontal_blank_space = check_for_surrounding_whitespace(grid_row, grid_row_index, grid_row.index(colour), "x")
        vertical_blank_space = check_for_surrounding_whitespace(grid_row, grid_row_index, grid_row.index(colour), "y")
        if horizontal_blank_space || vertical_blank_space
          next_fill_coordinate_to_populate = [grid_row_index, grid_row.index(colour)]
        end
        break
      end
    end
    next_fill_coordinate_to_populate
  end

  def check_for_surrounding_whitespace(grid_row, grid_row_index, grid_column_index, axis)
    if axis == "x"
      axis_increment = (grid_column_index + 1 <= @columns-1) ? grid_column_index + 1 : nil
      axis_decrement = (grid_column_index - 1 >= 0) ? grid_column_index - 1 : nil
      values_to_compare = [axis_increment, axis_decrement].compact
      whitespace_matches = values_to_compare.map{|index_value| grid_row[index_value] == "O"}
    else
      axis_increment = (grid_row_index + 1 <= @rows-1) ? grid_row_index + 1 : nil
      axis_decrement = (grid_row_index - 1 >= 0) ? grid_row_index - 1 : nil
      values_to_compare = [axis_increment, axis_decrement].compact
      whitespace_matches = values_to_compare.compact.map{|row|  @grid[row][grid_column_index] == "O"}
    end

    whitespace_matches.index(true)
  end

end
