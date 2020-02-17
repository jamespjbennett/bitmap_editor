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
    next_fill_colour_coordinate = next_fill_colour_with_empty_surrounding(colour)
    if next_fill_colour_coordinate
      until !next_fill_colour_coordinate
        fill_surrounding_area(next_fill_colour_coordinate, colour)
        next_fill_colour_coordinate = next_fill_colour_with_empty_surrounding(colour)
      end
    end
  end

  def next_fill_colour_with_empty_surrounding(colour)
    next_fill_coordinate_to_populate = nil
    @grid.each_with_index do |grid_row, grid_row_index|
      if grid_row.index(colour)
        horizontal_blank_space = check_for_surrounding_whitespace(grid_row, grid_row_index, "x", colour)
        vertical_blank_space = check_for_surrounding_whitespace(grid_row, grid_row_index, "y", colour)
        if horizontal_blank_space.any? || vertical_blank_space.any?
          first_match =  (vertical_blank_space + horizontal_blank_space)[0]
          next_fill_coordinate_to_populate = [grid_row_index, first_match]
          break
        end
      end
    end
    next_fill_coordinate_to_populate
  end

  def check_for_surrounding_whitespace(grid_row, grid_row_index, axis, colour)
    if axis == "x"
      whitespace_matches = grid_row.each_with_index.select{|value, index| horizontal_match(value, grid_row, index, colour)}
    else
      whitespace_matches = grid_row.each_with_index.select{|value, index|  vertical_match(value, colour, grid_row_index, index)}
    end
    whitespace_matches.map{|match| match[1]}
  end

  def horizontal_match(value, grid_row, index, colour)
    value_colour_match = value == colour
    horizontal_match_below = ( (index-1) >= 0 ) ? grid_row[index-1] == "O" : false
    horizontal_match_above = grid_row[index+1] == "O"
    value_colour_match && (horizontal_match_below || horizontal_match_above)
  end

  def vertical_match(value,colour, grid_row_index, index)
    value_colour_match = value == colour
    vertical_match_below = @grid[grid_row_index + 1] ? @grid[grid_row_index + 1][index] == "O" : false
    vertical_match_above = ((grid_row_index  - 1) >= 0) ? @grid[grid_row_index - 1][index] == "O" : false
    value_colour_match && (vertical_match_below || vertical_match_above)
  end


  def fill_surrounding_area(coordinate, colour)
    # horizontal
    row_to_target = @grid[coordinate[0]]
    index_to_target = coordinate[1]
    loop_and_fill_specific_row_or_column(row_to_target, index_to_target, colour)
    # reverse horizontal
    reversed_row_to_target = row_to_target.reverse
    reversed_index_to_target = @columns -  coordinate[1] - 1
    loop_and_fill_specific_row_or_column(reversed_row_to_target, reversed_index_to_target, colour)
    @grid[coordinate[0]] = reversed_row_to_target.reverse

    # VERTICAL
    transposed_grid = @grid.transpose
    column_to_target = @grid.transpose[coordinate[1]]
    index_to_target = coordinate[0]
    loop_and_fill_specific_row_or_column(column_to_target, index_to_target, colour)
    # reverse vertical
    reversed_column_to_target = column_to_target.reverse
    reversed_index_to_target = @rows -  coordinate[0] - 1
    loop_and_fill_specific_row_or_column(reversed_column_to_target, reversed_index_to_target, colour)
    updated_grid_column = reversed_column_to_target.reverse
    @grid.each_with_index{|row, index| row[coordinate[1]] = updated_grid_column[index]}
  end


  def loop_and_fill_specific_row_or_column(column_or_row, index, colour)
    until ![colour, "O"].include?(column_or_row[index])
      column_or_row[index] = colour
      index += 1
    end
  end
end
