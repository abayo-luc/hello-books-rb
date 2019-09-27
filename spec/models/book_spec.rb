require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { create(:book) }
  describe 'validation' do
    describe 'required attributes' do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:isbn) }
      it { should validate_presence_of(:page_number) }
      it { should validate_presence_of(:language) }
    end
    describe 'unique attributes' do
      subject { create(:book) }
      it { should validate_uniqueness_of(:title) }
      it { should validate_uniqueness_of(:isbn).case_insensitive }
    end

    describe 'isbn validation' do
      newBook = described_class.new({ title: Faker::Book.unique.title,
        isbn: '978-0-596-52068-7',
        language: 'French', page_number: 245 })
      context 'when isbn is valid' do
        it 'book should be valid' do
          newBook.isbn = '978-0-596-52068-7'
          expect(newBook).to be_valid
        end
      end
      context 'when isbn is invalid' do
        it 'book should be invalid' do
          newBook.isbn = '978-0-596-52068-7kjalf'
          expect(newBook).to_not be_valid
        end
      end
    end
  end
end
