class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 30}
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


  scope :handle_including, -> (str) { where("handle LIKE ?", "%" + User.sanitize_sql_like(str) + "%") }
  scope :handle_starting_by, -> (str) { where("handle LIKE ?", User.sanitize_sql_like(str) + "%") }
  scope :with_tweets, -> { select("*, (SELECT COUNT(*) from tweets where tweets.user_id = users.id) as tweets_count").where("tweets_count > 0") }
  scope :without_tweets, -> { select("*, (SELECT COUNT(*) from tweets where tweets.user_id = users.id) as tweets_count").where("tweets_count = 0") }
  scope :other_than, -> (id) { User.where.not(id: id) }

end
