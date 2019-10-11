require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Author Association' do
    it 'should have and belongs to many books' do
      assoc = described_class.reflect_on_association(:books)
      expect(assoc.macro).to eql(:has_and_belongs_to_many)
    end
  end
  describe '#actions' do
    it 'should down case category name before save' do
      category = described_class.new(name: 'HELLO book')
      category.save!
      expect(category.name).to eql('Hello Book')
    end
  end

  describe '#find_categories' do
    context 'shoiuld raise an error ' do
      it 'if argument is not an array' do
        described_class.find_categories('yes')
      rescue StandardError => e
        expect(e.message).to eql('Categories should be an arry of strings')
      end
      it 'if argument is not an array of string ' do
        described_class.find_categories([{ 'name' => 'hello word' }])
      rescue StandardError => e
        expect(e.message).to eql('Categories should be an arry of strings')
      end
      it 'if argument is an empty array' do
        described_class.find_categories([])
      rescue StandardError => e
        expect(e.message).to eql('Categories should be an arry of strings')
      end
    end
    context 'if valid argument provided' do
      before { described_class.create(name: 'Motivation') }
      it 'should return array of categories' do
        categories = described_class.find_categories(['motivation'])
        expect(categories.size).to eql(1)
        expect(categories.first.name).to eql('Motivation')
      end

      it 'should return an empy array ' do
        categories = described_class.find_categories(['take me to the ligend'])
        expect(categories.size).to eql(0)
      end
    end
  end
end
