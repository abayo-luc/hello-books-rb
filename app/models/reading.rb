class Reading < ApplicationRecord
  enum status: { pending: 'pending', borrowed: 'borrowed', returned: 'returned' }
  validates_uniqueness_of :user_id, scope: :book_id, message: 'Book already added to the list'
  belongs_to :user
  belongs_to :book
  def borrow!
    self.borrowed? ? self.update(status: 'returned') : self.update(status: 'borrowed')
  end
end
