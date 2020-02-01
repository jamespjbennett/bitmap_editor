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
end
