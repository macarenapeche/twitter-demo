require 'csv'

class FindLikesJob 
  include Sidekiq::Job
  queue_as :default

  def add_likes_to_csv(likes, date_range)
    rows = [[], []]
    date_range.each do |date|
      rows[0] << date.strftime("%d/%m/%Y")
      rows[1] << likes.select { |like| like.created_at.strftime("%d/%m/%Y") == date.strftime("%d/%m/%Y") }.count
    end

    CSV.open("./find_likes.csv", "wb") do |csv|
      csv << rows[0]
      csv << rows[1]
    end
  end

  def perform(user_id, start_date, end_date)
    user = User.find(user_id)
    date_range = (Date.parse(start_date)..Date.parse(end_date))
    likes = Like.where(tweet: user.tweets, created_at: date_range)

    add_likes_to_csv(likes, date_range)
  end
end
