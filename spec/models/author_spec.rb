require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'Author Association' do
    it 'should have and belongs to many books' do
      assoc = described_class.reflect_on_association(:books)
      expect(assoc.macro).to eql(:has_and_belongs_to_many)
    end
  end
  describe 'Author validation' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:bio) }
    it { should validate_presence_of(:country) }
    it 'shoudl validate uniquness of name' do
      subject { create(:author) }
      validate_uniqueness_of(:name).case_insensitive
    end
  end
end
