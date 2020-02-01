require_relative '../lib/bitmap_image'

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
        @bitmap_image.generate_grid("I 251 500")
        @grid = @bitmap_image.instance_variable_get(:@grid)
      end

      it 'should not populate the grid intance variable' do
      end
    end
  end

end
