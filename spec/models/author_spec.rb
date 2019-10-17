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

  describe '#find_authors' do
    context 'shoiuld raise an error ' do
      it 'if argument is not an array' do
        described_class.find_authors('yes')
      rescue StandardError => e
        expect(e.message).to eql('Authors should be an arry of strings')
      end
      it 'if argument is not an array of string ' do
        described_class.find_authors([{ 'name' => 'hello word' }])
      rescue StandardError => e
        expect(e.message).to eql('Authors should be an arry of strings')
      end
    end
    context 'if valid argument provided' do
      subject { described_class.create(name: 'Newton L.C', country: 'Rwanda') }
      it 'should return array of authors' do
        authors = described_class.find_authors([subject.name])
        expect(authors.size).to eql(1)
        expect(authors.first.name).to eql('Newton L.C')
      end

      it 'should return an empy array ' do
        authors = described_class.find_authors(['take me to the ligend'])
        expect(authors.size).to eql(0)
      end
    end
  end
end
