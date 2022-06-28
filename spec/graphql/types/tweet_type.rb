RSpec.describe Types::TweetType do
  include_context "when user exists"
  include_context "when tweet exists"
  subject(:response) { Schema.execute(query, variables: variables).to_h }

  let!(:query) { <<~GRAPHQL }
    query($id: ID!) {
      tweet(id: $id) {
        id
        content
        userId
        likeCount
        commentCount
      }
    }
  GRAPHQL
  let!(:variables) { {id: tweet.id} }

  it "returns the correct data" do
    expect(response).to eq({
      "data" => {
        "tweet" => {
          "id" => tweet.id.to_s,
          "content" => tweet.content,
          "userId" => tweet.user_id.to_s,
          "likeCount" => tweet.likes.count,
          "commentCount" => tweet.comments.count
        } 
      }
    })
  end
end
