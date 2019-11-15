class User < ApplicationRecord
  before_create :default_url
  before_update :default_url
  enum role: { user: 'user', admin: 'admin', super_admin: 'super_admin' }
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  validates_format_of :email, with: Devise.email_regexp, message: 'Invalid email'
  validates :phone_number, allow_nil: true, numericality: true, length: { minimum: 10, maximum: 15 }
  validates_format_of :avatar, with: URI.regexp(%w(http https)), allow_nil: true, message: 'Invalid url'
  has_many :readings
  has_many :books, through: :readings

  def formated_email
    email&.downcase
  end
  def default_url
    unless self.avatar?
      name = "#{self.first_name}+#{self.last_name}" if self.first_name && self.last_name
      name = self.email unless name
      self.avatar = "https://ui-avatars.com/api/?name=#{name}&size=800"
    end
  end
  def change_role(role)
    if %w[admin user].include?(role)
      update(role: role) unless super_admin?
    else
      raise 'Role should be user or admin'
    end
  end
end
