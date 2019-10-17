class Author < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }
  validates_presence_of :name, :country
  validates_length_of :bio, minimum: 250, maximum: 500, message: 'Bio should be between 250-500 charcters', allow_blank: true
  has_and_belongs_to_many :books
  before_save :downcase_category_name
  def self.find_authors(authors = [])
    where('name IN (?)', authors.map { |author| author.downcase.titleize })
  rescue StandardError
    raise 'Authors should be an arry of strings'
  end

  private
    def downcase_category_name
      self.name = name.downcase.titleize
    end
end
