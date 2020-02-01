require_relative '../lib/bitmap_image'

RSpec.describe "BitmapImage" do

  before(:each) do
    @bitmap_image = BitmapImage.new
  end

  describe 'initialization' do
    it 'should initialize with a rows attribute' do
      expect(@bitmap_image.rows).to eq(nil)
    end
    it 'should initialize with a columns attribute'
    it 'should initialize with a grid attribute'
  end

end
