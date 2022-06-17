class Tweet < ApplicationRecord
  validates :content, presence: true, length: { maximum: 280 }
  validates :user_id, presence: true
  
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
