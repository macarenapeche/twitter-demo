class User < ApplicationRecord

  validates :name, presence: true, length: { minimum: 2, maximum: 30}
  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_format_of :handle, with: /\A[\w\d_-]+\z/

  
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :followers, class_name: "Follow", foreign_key: "user_id"
  has_many :following, class_name: "Follow", foreign_key: "follower_id"
end
