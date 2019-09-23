class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_format_of :email, with:  Devise.email_regexp, message: 'Invalid email'

  def formated_email
    self.email&.downcase
  end
end
