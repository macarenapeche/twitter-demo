RSpec.describe Types::Like do
  include_context "when user exists"
  include_context "when tweet exists"
  subject(:response) { Schema.execute(query, variables: variables).to_h }

  let!(:query) { <<~GRAPHQL }
    query($id: ID!) {
      like(id: $id) {
        id
        tweetId
        userId
      }
    }
  GRAPHQL
  let!(:variables) { {id: like.id} }
  let!(:another_user) { User.create(name: "user", handle: "user", email: "email@gmail.com") }
  let!(:like) { Like.create(tweet_id: tweet.id, user_id: another_user.id) }

  it "returns the correct data" do
    expect(response).to eq({
      "data" => {
        "like" => {
          "id" => like.id.to_s,
          "tweetId" => like.tweet_id.to_s,
          "userId" => like.user_id.to_s
        }
      }
    })
  end
end
