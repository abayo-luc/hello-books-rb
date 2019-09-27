class Category < ApplicationRecord
  validates :name,  uniqueness: { case_sensitive: false }
  has_and_belongs_to_many :books
end
