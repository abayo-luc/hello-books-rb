class Book < ApplicationRecord
  validates_presence_of :title, :isbn, :page_number, :language, on: :create
  validates_uniqueness_of :title, :isbn, uniqueness: { case_sensitive: false }
  validates :isbn,
            format: {
              with: /\A(?:ISBN(?:-1[03])?:?●)?(?=[-0-9●]{17}$|[-0-9X●]{13}$|[0-9X]{10}$)(?:97[89][-●]?)?[0-9]{1,5}[-●]?(?:[0-9]+[-●]?){2}[0-9X]\z/i,
              message: 'Invalid ISBN'
            }
  has_and_belongs_to_many :categories, join_table: 'books_categories'
  has_and_belongs_to_many :authors, join_table: 'authors_books'
end
