require_relative '../lib/bitmap_editor'
require 'tempfile'
require 'pry'

RSpec.describe "BitmapEditor" do

  before(:each) do
    @bitmap_editor = BitmapEditor.new
  end

  describe 'new bitmap image regex matches' do
    context 'valid regex' do
      it 'should correctly match against command for new bitmap image' do
        valid_inputs = ["I 5 6", "i  56   200", "I 5 6  "]
        valid_inputs.each{|input| expect(input.match(@bitmap_editor.new_bitmap_image_command)).not_to be_nil}
      end
    end
    context 'invalid regex' do
      it 'should not provide a match for invalid commands ' do
        invalid_inputs = ["I 5 6 7", "I 5", "I5 6", "I 56", "I I 56", "I 5 A"]
        invalid_inputs.each{|input| expect(input.match(@bitmap_editor.new_bitmap_image_command)).to be_nil}
      end
    end
  end

  describe 'new single dot command regex matches' do
    context 'valid regex' do
      it 'should correctly match against command for single dot colouring' do
        valid_inputs = ["L 1 3 A", "l  13   200 D", "L 1 3 A   "]
        valid_inputs.each{|input| expect(input.match(@bitmap_editor.single_pixel_colour_command)).not_to be_nil}
      end
    end

    context 'invalid regex' do
      it 'should not provide a match for invalid commands for single dot colouring ' do
        invalid_inputs = ["l1 3 a", "L 1 3 A   5", "L 1 3 A5", "L A 1 3"]
        invalid_inputs.each{|input| expect(input.match(@bitmap_editor.single_pixel_colour_command)).to be_nil}
      end
    end
  end


  describe 'fill command' do
    context 'valid regex' do
      it 'should correctly match against command for filling in an area with a colour' do
        valid_inputs = ["F 2 2 R", "f   2 2 r", "F 2 2 R   "]
        valid_inputs.each{|input| expect(input.match(@bitmap_editor.fill_colour_command)).not_to be_nil}
      end
    end
    context 'invalid regex' do
      it 'should not provide a  match for invaluid command for filling in an area with a colour' do
        invalid_inputs = ["f2 2 r", "f 2 r", "F 2 R 2"]
        invalid_inputs.each{|input| expect(input.match(@bitmap_editor.fill_colour_command)).to be_nil}
      end
    end
  end


  describe 'new vertical line command regex matches' do
    context 'valid regex' do
      it 'should correctly match against command for vertical line colouring' do
        valid_inputs = ["V 2 3 6 W", "v  13   200 4 D", "V 1 3 20 A   "]
        valid_inputs.each{|input| expect(input.match(@bitmap_editor.vertical_line_command)).not_to be_nil}
      end
    end
    context 'invalid regex' do
      it 'should not providde a match for invalid commands for vertical line colouring' do
        invalid_inputs = ["v 2 3 w", "V2 3 6 A", "V 2 36 W", "VA 2 3 6 W"]
        invalid_inputs.each{|input| expect(input.match(@bitmap_editor.vertical_line_command)).to be_nil}
      end
    end
  end

  describe 'new horizontal line command regex matches' do
    context 'valid regex' do
      it 'should correctly match against command for horizontal line colouring' do
        valid_inputs = ["H 3 5 2 Z", "h  13   200 4 D", "H 1 3 20 A   "]
        valid_inputs.each{|input| expect(input.match(@bitmap_editor.horizontal_line_command)).not_to be_nil}
      end
    end
    context 'invalid regex' do
      it 'should not providde a match for invalid commands for horizontal line colouring' do
        invalid_inputs = ["h 3 5 Z", "H5 5 2 A", "H 3 52 W", "HA 3 5 2 Z"]
        invalid_inputs.each{|input| expect(input.match(@bitmap_editor.horizontal_line_command)).to be_nil}
      end
    end
  end


  describe 'show bitmap image command' do
    it 'should correctly match against command for showing bitmap image' do
      valid_inputs = ["s", "S", "  s  "]
      valid_inputs.each{|input| expect(input.match(@bitmap_editor.show_image_command)).not_to be_nil}
    end

    it 'should correctly identify showing bitmap command as invalid' do
      invalid_inputs = ["sa", "s 1"]
      invalid_inputs.each{|input| expect(input.match(@bitmap_editor.show_image_command)).to be_nil}
    end
  end


  describe 'clear bitmap image command' do
    it 'should correctly match against command for clearing bitmap image' do
      valid_inputs = ["c", "C", "  c  "]
      valid_inputs.each{|input| expect(input.match(@bitmap_editor.clear_command)).not_to be_nil}
    end

    it 'should correctly identify clear command as invalid' do
      invalid_inputs = ["ca", "c 1"]
      invalid_inputs.each{|input| expect(input.match(@bitmap_editor.clear_command)).to be_nil}
    end
  end


  describe 'running the file reader' do
    context 'valid file content' do
      it 'should create a new bitmap image when the correct command is input' do
        file = open_and_write_temp_file("i 5 6")
        @bitmap_editor.run(file)
        expect(@bitmap_editor.instance_variable_get(:@grid)).not_to be_nil
        remove_temp_file(file)
      end

      it 'should colour a dot when the input file provides the correct set of commands' do
        file = open_and_write_temp_file("i 5 6\nL 1 3 A")
        @bitmap_editor.run(file)
        grid = @bitmap_editor.instance_variable_get(:@grid)
        expect(grid[2][0]).to eq("A")
        remove_temp_file(file)
      end
    end

    context 'invalid file content' do
      it 'should not attempt to execute actions on grid if it doesnt yet exist' do
        file = open_and_write_temp_file("L 1 3 A")
        expect { @bitmap_editor.run(file) }.to output("No Grid created!\n").to_stdout
        expect { @bitmap_editor.run(file) }.not_to raise_error
        remove_temp_file(file)
      end
    end
  end

  def open_and_write_temp_file(content)
    file = Tempfile.new('test_instructions')
    file.write(content)
    file.read
    file
  end

  def remove_temp_file(file)
    file.close
    file.unlink
  end
end
