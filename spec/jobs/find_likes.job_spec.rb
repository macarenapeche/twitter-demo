require 'sidekiq/testing' 
Sidekiq::Testing.fake!

RSpec.describe FindLikesJob do
  let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@gmail.com", password: "password") }
  let!(:another_user) { User.create(name: "user", handle: "handle", email: "email@gmail.com", password: "password") }
  let!(:tweet) { Tweet.create(content: "tweet", user_id: user.id) }
  let!(:like) { Like.create(tweet_id: tweet.id, user_id: another_user.id, created_at: "10/08/2022") }

  it 'performs the job' do
    FindLikesJob.perform_sync(user.id, "10/08/2022", "11/08/2022")
    file = CSV.open("./find_likes.csv", "r")
  
    expect(file.read).to eq([
      ["10/08/2022", "11/08/2022"],
      ["1", "0"]
    ])
  end
end
