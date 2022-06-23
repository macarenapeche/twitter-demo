class Like < ApplicationRecord
  validates :user_id, presence: true
  validates :tweet_id, presence: true
  validates_uniqueness_of :user_id, scope: :tweet_id, message: "already liked this tweet"

  belongs_to :tweet
  belongs_to :user

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_tweet, ->(tweet_id) { where(tweet_id: tweet_id) }
end
