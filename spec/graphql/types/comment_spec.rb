RSpec.describe Types::Comment do
  include_context "when user exists"
  include_context "when tweet exists"
  subject(:response) { Schema.execute(query, variables: variables).to_h }

  let!(:query) { <<~GRAPHQL }
    query($id: ID!) {
      comment(id: $id) {
        id
        tweetId
        userId
        content
      }
    }
  GRAPHQL
  let!(:variables) { {id: comment.id} }
  let!(:another_user) { User.create(name: "user", handle: "user", email: "email@gmail.com") }
  let!(:comment) { Comment.create(tweet_id: tweet.id, user_id: another_user.id, content: "cool tweet") }

  it "returns the correct data" do
    expect(response).to eq({
      "data" => {
        "comment" => {
          "id" => comment.id.to_s,
          "tweetId" => comment.tweet_id.to_s,
          "userId" => comment.user_id.to_s,
          "content" => comment.content
        }
      }
    })
  end
end
