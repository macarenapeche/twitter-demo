class Comment < ApplicationRecord
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validates :tweet_id, presence: true
  
  belongs_to :user
  belongs_to :tweet
end
