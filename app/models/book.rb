class Book < ActiveRecord::Base
  belongs_to :user
  has_many :book_histories
  has_many :posts
  has_many :comments, through: :posts
  validates :title, presence: true
  validates :isbn, presence: true, uniqueness: true
  validates :description, presence: true
end
