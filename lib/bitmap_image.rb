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

  def colour_single_pixel(command)
    int_values = command_integer_values(command)
    x_axis_coordinate = int_values[0] - 1
    y_axis_coordinate = int_values[1] - 1
    return puts "Coordinates out of bounds" if !within_bounds?([x_axis_coordinate], [y_axis_coordinate])
    colour = command_string_values(command).last
    @grid[x_axis_coordinate][y_axis_coordinate] = colour
  end

  def draw_vertical_line(command)
    int_values = command_integer_values(command)
    x_axis_coordinate = int_values[0].to_i - 1
    y_axis_coordinate_1 = int_values[1].to_i - 1
    y_axis_coordinate_2 = int_values[2].to_i - 1
    return puts "Coordinates out of bounds" if !within_bounds?([x_axis_coordinate], [y_axis_coordinate_1, y_axis_coordinate_2])
    colour = command_string_values(command).last
    @grid[y_axis_coordinate_1..y_axis_coordinate_2].each{|row| row[x_axis_coordinate] = colour}
  end
end
