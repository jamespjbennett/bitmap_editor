class BitmapImage

  def initialize
    @rows = nil
    @columns = nil
    @rows = nil
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

  def colour_single_pixel(command)
    x_axis_coordinate = command_integer_values(command)[0].to_i
    y_axis_coordinate = command_integer_values(command)[1].to_i
    colour = command_string_values(command).last
    @grid[x_axis_coordinate][y_axis_coordinate] = colour
  end
end
