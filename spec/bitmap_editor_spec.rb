require_relative '../lib/bitmap_editor'

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
      it 'should correctly match against command for new bitmap image' do
        valid_inputs = ["L 1 3 A", "l  13   200 D", "L 1 3 A   "]
        valid_inputs.each{|input| expect(input.match(@bitmap_editor.single_pixel_colour_command)).not_to be_nil}
      end
    end
  end
  it 'should correctly match against command for vertical line on bitmap image'
  it 'should correctly match against command for horizontal line on bitmap image'
  it 'should correctly match against command for showing bitmap image'
  it 'should correctly match against command for clearing bitmap image'


end
