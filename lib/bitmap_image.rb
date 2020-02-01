class BitmapImage

  def initialize
    @rows = nil
    @columns = nil
    @rows = nil
  end

  def generate_grid(command)
    int_values = command.scan(/\d+/).map(&:to_i)
    @rows = int_values[1]
    @columns = int_values[0]
    @grid = Array.new(@rows) {Array.new(@columns) {'O'}}
  end
end
