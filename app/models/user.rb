class User < ActiveRecord::Base
  has_many :books
  has_many :book_histories
  before_save { self.email = email.downcase }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, length: { minimum: 8 }, presence: true
  has_secure_password
end
