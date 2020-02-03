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
      case line
      when new_bitmap_image_command
        @bitmap_image.generate_grid(line)
      when single_pixel_colour_command
        puts "single pixel colour command"
      else
        puts 'unrecognised command :('
      end
    end
  end

  def new_bitmap_image_command
    /[iI]\s+\d+\s+\d+(\z||\s*)\z/
  end

  def single_pixel_colour_command
    /[lL]\s+\d+\s+\d+\s+[a-zA-Z]\s*\z/
  end

end
