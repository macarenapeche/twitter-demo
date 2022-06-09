class Tweet < ApplicationRecord
  validates_presence_of :content
  validates :content, length: { maximum: 280 }
  
  belongs_to :user
  has_many :likes, dependent: :destroy
end
