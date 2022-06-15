class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 30}
  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_format_of :handle, with: /\A[\w\d_-]+\z/

  
  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follows
  has_many :followers, through: :follows, class_name: 'User'
  has_many :following, through: :follows, foreign_key: :follower_id, source: :user
end
