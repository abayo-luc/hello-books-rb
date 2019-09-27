require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'Author Association' do
    it 'should have and belongs to many books' do
      assoc = described_class.reflect_on_association(:books)
      expect(assoc.macro).to eql(:has_and_belongs_to_many)
    end
  end
end
