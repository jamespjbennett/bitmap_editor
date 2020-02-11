require_relative '../lib/bitmap_image'
require 'pry'

RSpec.describe "BitmapImage" do

  before(:each) do
    @bitmap_image = BitmapImage.new
  end

  describe 'initialization' do
    it 'should initialize with a rows attribute' do
      expect(@bitmap_image.instance_variable_get(:@row)).to eq(nil)
    end

    it 'should initialize with a columns attribute' do
      expect(@bitmap_image.instance_variable_get(:@columns)).to eq(nil)
    end

    it 'should initialize with a grid attribute' do
      expect(@bitmap_image.instance_variable_get(:@grid)).to eq(nil)
    end
  end


  describe 'grid generation' do
    context 'valid command' do
      before(:each) do
        @bitmap_image.generate_grid("I 5 6")
        @grid = @bitmap_image.instance_variable_get(:@grid)
      end

      it 'should successfully change the value of grid' do
        expect(@grid).not_to be_nil
      end
      it 'should successfully change the value of rows' do
        expect(@bitmap_image.instance_variable_get(:@rows)).not_to be_nil
      end
      it 'should successfully change the value of columns' do
        expect(@bitmap_image.instance_variable_get(:@columns)).not_to be_nil
      end
      it 'should create a multidimensional array' do
        expect(@grid.class).to eq(Array)
        expect(@grid.map(&:class).uniq).to eq([Array])
      end
      it 'should create the correct number of rows as specified by the command' do
        expect(@grid.length).to eq(6)
      end
      it 'should create the correct length of individual rows as specified by the command' do
        expect(@grid.map(&:length).uniq).to eq([5])
      end
      it 'should initialize all values as "O"' do
        expect(@grid.flatten.uniq).to eq(["O"])
      end
    end

    context 'invalid command' do
      before(:each) do
        @bitmap_image.generate_grid("I 251 251")
        @grid = @bitmap_image.instance_variable_get(:@grid)
      end

      it 'should not populate the grid intance variable' do
        expect(@grid).to eq(nil)
      end
    end
  end

  describe 'new colour dot' do
    before(:each) do
      @bitmap_image.generate_grid("I 5 6")
    end

    context 'valid command' do
      it 'should successfully change the value of the specified coordinate to the specified colour' do
        @bitmap_image.colour_single_pixel("L 1 3 A")
        grid = @bitmap_image.instance_variable_get(:@grid)
        expect(grid[2][0]).to eq("A")
      end

    end
    context 'invalid command' do
      it 'should prevent coloring if the  coordinates are out of bounds' do
        @bitmap_image.colour_single_pixel("L 6 6 A")
        grid = @bitmap_image.instance_variable_get(:@grid)
        expect(grid[0][2]).not_to eq("A")
      end
    end
  end

  describe 'new vertical line' do
    before(:each) do
      @bitmap_image.generate_grid("I 5 6")
    end

    context 'valid command' do
      before(:each) do
        @bitmap_image.draw_vertical_line("V 2 3 6 W")
        @grid = @bitmap_image.instance_variable_get(:@grid)
      end
      it 'should draw a vertical line in the column that matches the command' do
        expect(@grid.map{|row| row[1]}.count("W")).to eq(4)
        expect(@grid.map{|row| row[1]}.count("O")).to eq(2)
      end
    end

    context 'invalid command' do
      it 'should prevent coloring if the x coordinate is out of bounds' do
        @bitmap_image.draw_vertical_line("V 6 3 6 W")
        grid = @bitmap_image.instance_variable_get(:@grid)
        expect(grid.flatten.uniq).to eq(["O"])
      end
      it 'should prevent coloring if a y coordinate is out of bounds' do
        @bitmap_image.draw_vertical_line("V 2 3 7 W")
        grid = @bitmap_image.instance_variable_get(:@grid)
        expect(grid.flatten.uniq).to eq(["O"])
      end
    end
  end

  describe 'new horizontal line' do
    before(:each) do
      @bitmap_image.generate_grid("I 5 6")
    end

    context 'valid command' do
      before(:each) do
        @bitmap_image.draw_horizontal_line("H 3 5 2 Z")
        @grid = @bitmap_image.instance_variable_get(:@grid)
      end
      it 'should draw a horitontal line in the column that matches the command' do
        expect(@grid[1]).to eq(["O", "O", "Z", "Z", "Z"])
      end
    end

    context 'invalid command' do
      it 'should not draw a line if the coordinates are out of bounds' do
        @bitmap_image.draw_horizontal_line("H 3 6 2 Z")
        grid = @bitmap_image.instance_variable_get(:@grid)
        expect(grid.flatten.uniq).to eq(["O"])
      end
    end
  end


  describe 'fill area' do
    before(:each) do
      @bitmap_image.generate_grid("I 5 6")
    end

    context 'valid command' do
      it 'should fill the whole grid with the colour if there are no bounds' do
        @bitmap_image.fill_colour("F 2 2 R")
        grid = @bitmap_image.instance_variable_get(:@grid)
        expect(grid.flatten.uniq).to eq(["R"])
      end
      it 'should fill the remaining coordinates if the grid is coloured but contains no full lines'
      it 'should fill a bounded area with the colour if there is a full line partioning the grid'

    end
    context 'invalid command' do

    end
  end

  describe 'show image' do
    it 'should print out the bitmap grid' do
      @bitmap_image.generate_grid("I 5 6")
      @bitmap_image.colour_single_pixel("L 1 3 A")
      @bitmap_image.draw_horizontal_line("H 3 5 2 Z")
      @bitmap_image.draw_vertical_line("V 2 3 6 W")
      expected_output = "O O O O O\nO O Z Z Z\nA W O O O\nO W O O O\nO W O O O\nO W O O O\n"
      expect { @bitmap_image.display_grid }.to output(expected_output).to_stdout
    end
  end

  describe 'clear image' do
    it 'should clear the image from the grid' do
      @bitmap_image.generate_grid("I 5 6")
      @bitmap_image.draw_horizontal_line("H 3 5 2 Z")
      @bitmap_image.create_clear_grid
      grid = @bitmap_image.instance_variable_get(:@grid)
      expect(grid.flatten.uniq).to eq(["O"])
    end
  end

end
