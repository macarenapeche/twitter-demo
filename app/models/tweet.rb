class Tweet < ApplicationRecord
  validates :content, presence: true, length: { maximum: 280 }
  validates :user_id, presence: true
  
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  scope :popular, -> (limit) { select(:id, :user_id, :content, "(SELECT COUNT(*) FROM likes WHERE likes.tweet_id = tweets.id) as likes_count").order(likes_count: :desc).limit(limit) }
  scope :content_including, -> (str) { where("content LIKE ?", "%" + User.sanitize_sql_like(str) + "%") }

end
