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
        @bitmap_image = BitmapImage.new
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
        @bitmap_image = BitmapImage.new
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
      @bitmap_image = BitmapImage.new
      @bitmap_image.generate_grid("I 5 6")
    end

    context 'valid command' do
      it 'should successfully change the value of the specified coordinate to the specified colour' do
        @bitmap_image.colour_single_pixel("L 1 3 A")
        grid = @bitmap_image.instance_variable_get(:@grid)
        expect(grid[0][2]).to eq("A")
      end

    end
    context 'invalid command' do
      it 'should prevent coloring if the x coordinate is out of bounds' do
        @bitmap_image.colour_single_pixel("L 6 6 A")
        grid = @bitmap_image.instance_variable_get(:@grid)
        expect(grid[0][2]).not_to eq("A")
      end
    end
  end

  describe 'new vertical line' do
    before(:each) do
      @bitmap_image = BitmapImage.new
      @bitmap_image.generate_grid("I 5 6")
    end

    context 'valid command' do
      before(:each) do
        @bitmap_image.draw_vertical_line("V 2 3 6 W")
        grid = @bitmap_image.instance_variable_get(:@grid)
      end

    end
  end
end
