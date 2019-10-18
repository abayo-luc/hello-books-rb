require 'rails_helper'

RSpec.describe Reading, type: :model do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  describe 'readings validation' do
    before { described_class.create(user_id: user.id, book_id: book.id) }
    it 'should validate uniquness of user_id scoped to book_id' do
      reading_list = described_class.create(user_id: user.id, book_id: book.id)
      expect(reading_list.errors['user_id']).to contain_exactly('Book already added to the list')
    end
  end
  describe '#borrow!' do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:reading) { Reading.create(user_id: user.id, book_id: book.id) }
    it 'should status be pending initially' do
      expect(reading.status).to eql('pending')
    end
    it 'should chanege status to borrowed' do
      reading.borrow!
      expect(reading.status).to eql('borrowed')
      reading.borrow!
      expect(reading.status).to eql('returned')
    end
  end
end
