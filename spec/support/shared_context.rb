RSpec.shared_context 'when user exists' do
  let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
  let!(:user_id) { user.id }
end

RSpec.shared_context 'when tweet exists' do
  let!(:tweet) { Tweet.create(content: 'some content', user_id: user.id) }
  let!(:tweet_id) { tweet.id }
end
