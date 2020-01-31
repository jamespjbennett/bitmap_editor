RSpec.describe "BitmapEditor" do

  describe 'regex matches' do
    it 'should correctly match against command for new bitmap image' do
      bitmap_editor = BitmapEditor.new
      valid_input = "I 5 6"
      expect(valid_input.match(clear_command)).not_to be_nil
    end
    it 'should correctly match against command for single dot on bitmap image'
    it 'should correctly match against command for vertical line on bitmap image'
    it 'should correctly match against command for horizontal line on bitmap image'
    it 'should correctly match against command for showing bitmap image'
    it 'should correctly match against command for clearing bitmap image'

  end

end
