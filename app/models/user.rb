class User < ApplicationRecord

  validates :name, presence: true, length: { minimum: 2, maximum: 30}
  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
end
