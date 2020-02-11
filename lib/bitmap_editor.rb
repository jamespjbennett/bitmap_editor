require_relative 'bitmap_image.rb'

class BitmapEditor

  def initialize(bitmap_image = BitmapImage.new)
    @bitmap_image = bitmap_image
    @grid = nil
  end


  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)
    File.open(file).each do |line|
      line = line.chomp
      return puts 'No Grid created!' if grid_required_but_not_created(line)
      case line
      when new_bitmap_image_command
        @grid = @bitmap_image.generate_grid(line)
      when single_pixel_colour_command
        @bitmap_image.colour_single_pixel(line)
      when vertical_line_command
        @bitmap_image.draw_vertical_line(line)
      when horizontal_line_command
        @bitmap_image.draw_horizontal_line(line)
      when show_image_command
        @bitmap_image.display_grid
      when clear_command
        @bitmap_image.create_clear_grid
      else
        puts 'unrecognised command :('
      end
    end
  end

  def grid_required_but_not_created(line)
    line.match(image_action?) && !@grid
  end

  def new_bitmap_image_command
    /[iI]\s+\d+\s+\d+(\z||\s*)\z/
  end

  def single_pixel_colour_command
    /[lL]\s+\d+\s+\d+\s+[a-zA-Z]\s*\z/
  end

  def vertical_line_command
    /[vV]\s+\d+\s+\d+\s+\d+\s+[a-zA-Z]\s*\z/
  end

  def horizontal_line_command
    /[hH]\s+\d+\s+\d+\s+\d+\s+[a-zA-Z]\s*\z/
  end

  def fill_colour_command
    /[fF]\s+\d+\s+\d+\s+[a-zA-Z]\s*\z/
  end

  def show_image_command
    /[sS]\s*\z/
  end

  def clear_command
    /[cC]\s*\z/
  end

  def image_action?
    Regexp.union([single_pixel_colour_command, vertical_line_command, horizontal_line_command, show_image_command, clear_command, fill_colour_command])
  end

end
