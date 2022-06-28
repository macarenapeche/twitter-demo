class Tweet < ApplicationRecord
  validates :content, presence: true, length: { maximum: 280 }
  validates :user_id, presence: true
  
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :content_including, -> (str) { where("content LIKE ?", "%" + User.sanitize_sql_like(str) + "%") }
  scope :popular, ->(limit) { select("*, (SELECT COUNT(*) FROM likes WHERE likes.tweet_id = tweets.id) as likes_count")
                              .order(likes_count: :desc, created_at: :desc).limit(limit) }
  scope :created_in_time_range, ->(time_range) { where(created_at: time_range) }
  scope :recent, -> { created_in_time_range(7.day.ago..Time.now) }
  scope :today, -> { created_in_time_range(Time.now.midnight..Time.now) }


  def likes_per_day
    Tweet.joins(:likes).where(id: id).group("DATE(likes.created_at)").count("likes.id")
  end

  def self.likes_per_day
    # result = Hash.new()
    # Tweet.includes(:likes).each do |tweet|
    #   result[tweet.id] = tweet.likes_per_day
    # end
    # result

    Tweet.includes(:likes).to_h do |tweet|
      [tweet.id, tweet.likes_per_day]
    end
  end

end
