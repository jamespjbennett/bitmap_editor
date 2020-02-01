require_relative '../lib/bitmap_image'

RSpec.describe "BitmapImage" do

  describe 'initialization' do
    it 'should initialize with a rows attribute' do
      bitmap_image = BitmapImage.new
      expect(bitmap_image.rows).not_to raise_error
    end
    it 'should initialize with a columns attribute'
    it 'should initialize with a grid attribute'
  end

end
