class User < ApplicationRecord
  enum role: { user: 'user', admin: 'admin', super_admin: 'super_admin' }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_format_of :email, with:  Devise.email_regexp, message: 'Invalid email'

  def formated_email
    self.email&.downcase
  end
  def change_role(role)
    if ['admin', 'user'].include?(role)
      self.update(role: role) unless self.super_admin?
    else
      raise 'Role should be user or admin'
    end
  end
end
