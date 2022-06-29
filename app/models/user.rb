class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30}
  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_format_of :handle, with: /\A[\w\d_-]+\z/

  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comment, dependent: :destroy

  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :pasive_follows, class_name: "Follow", foreign_key: :user_id, dependent: :destroy

  has_many :followers, through: :pasive_follows, source: :follower
  has_many :following, through: :active_follows, source: :user


  scope :handle_starting_by, -> (str) { where("handle LIKE ?", User.sanitize_sql_like(str) + "%") }
  scope :with_tweets, -> { where("(SELECT COUNT(*) from tweets where tweets.user_id = users.id) > 0") }
  scope :without_tweets, -> { where("(SELECT COUNT(*) from tweets where tweets.user_id = users.id) = 0") }
  scope :other_than, -> (id) { User.where.not(id: id) }
  
  def self.average_tweets_per_day
    tweet_count_table = User.left_joins(:tweets)
                             .select(:id, "DATE(tweets.created_at), COUNT(tweets.id) as tweets_count")
                             .group(:id, "DATE(tweets.created_at)")
    User.from(tweet_count_table).group(:id).average(:tweets_count)
  end

  def self.total_likes
    # User.left_joins(tweets: :likes).select(:id, "COUNT(likes.id) AS likes_count").group(:id)
    User.left_joins(tweets: :likes).group(:id).count("likes.id")
  end

  def self.with_most_likes
    User.find(
      # User.total_likes.order("COUNT(likes.id) DESC").first.id
      User.total_likes.max_by { |id, likes| likes }[0]
    )
  end

  def self.total_comments
    # User.left_joins(tweets: :likes).select("users.*, COUNT(likes.*) AS likes_count").group("users.id")
    User.left_joins(tweets: :comments).group(:id).count("comments.id")
  end

  def self.with_most_comments
    User.find(
      # User.total_comments.order ("COUNT(comments.id").first.id
      User.total_comments.max_by { |id, comments| comments }[0]
    )
  end

end
