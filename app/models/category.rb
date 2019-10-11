class Category < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }
  has_and_belongs_to_many :books
  before_save :downcase_category_name

  def self.find_categories(categories = [])
    where('name IN (?)', categories.map { |category| category.downcase.titleize })
  rescue StandardError
    raise 'Categories should be an arry of strings'
  end

  private
    def downcase_category_name
      self.name = name.downcase.titleize
    end
end
