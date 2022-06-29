RSpec.describe Types::User do
  include_context "when user exists"
  subject(:response) { Schema.execute(query, variables: variables).to_h }

  let!(:query) { <<~GRAPHQL }
    query($id: ID!) {
      user(id: $id) {
        id
        name
        handle
        email
        bio
        tweetCount
        followersCount
        followingCount
      }
    }
  GRAPHQL
  let!(:variables) { {id: user.id} }

  it "returns the correct data" do
    expect(response).to eq({
      "data" => {
        "user" => {
          "id" => user.id.to_s,
          "name" => user.name,
          "handle" => user.handle,
          "email" => user.email,
          "bio" => user.bio,
          "tweetCount" => user.tweets.count,
          "followersCount" => user.followers.count,
          "followingCount" => user.following.count
        }
      } 
    })
  end
end
