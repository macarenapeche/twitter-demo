class Like < ApplicationRecord
  validates :user_id, presence: true
  validates :tweet_id, presence: true
  validates_uniqueness_of :user_id, scope: :tweet_id, message: "already liked this tweet"

  belongs_to :tweet
  belongs_to :user

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_tweet, ->(tweet_id) { where(tweet_id: tweet_id) }

  def self.average_per_day
    likes_count_table = Like.select("DATE(created_at), COUNT(*) as likes_count").group("DATE(created_at)")
    Like.from(likes_count_table).average("likes_count")
  end

  def self.average_per_user
    likes_count_table = Like.select(:id, :user_id, "COUNT(*) as likes_count").group(:user_id)
    Like.from(likes_count_table).average("likes_count")
  end


  def self.average_per_tweet
    likes_count_table = Like.select(:id, :tweet_id, "COUNT(*) as likes_count").group(:tweet_id)
    Like.from(likes_count_table).average("likes_count")
  end
end
