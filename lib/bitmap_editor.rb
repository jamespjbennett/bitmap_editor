class BitmapEditor

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)
    
    File.open(file).each do |line|
      line = line.chomp
      case line
      when new_bitmap_image_command
          puts "new bitmap image command"
      when 'S'
          puts "There is no image"
      else
          puts 'unrecognised command :('
      end
    end
  end

  def new_bitmap_image_command
    /[iI]\s+\d+\s+\d+(\z||\s*)\z/
  end

end
