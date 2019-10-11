class User < ApplicationRecord
  enum role: { user: 'user', admin: 'admin', super_admin: 'super_admin' }
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  validates_format_of :email, with: Devise.email_regexp, message: 'Invalid email'

  def formated_email
    email&.downcase
  end

  def change_role(role)
    if %w[admin user].include?(role)
      update(role: role) unless super_admin?
    else
      raise 'Role should be user or admin'
    end
  end
end
