RSpec.describe Types::FollowType do
  include_context "when user exists"
  subject(:response) { Schema.execute(query, variables: variables).to_h }

  let!(:query) { <<~GRAPHQL }
    query($id: ID!) {
      follow(id: $id) {
        id
        userId
        followerId
      }
    } 
  GRAPHQL
  let!(:variables) { {id: follow.id} }
  let!(:follower) { User.create(name: "follower", handle: "follower", email: "follower@gmail.com") }
  let!(:follow) { Follow.create(user_id: user.id, follower_id: follower.id) }

  it "returns the correct data" do
    expect(response).to eq({
      "data" => {
        "follow" => {
          "id" => follow.id.to_s,
          "userId" => follow.user_id.to_s,
          "followerId" => follow.follower_id.to_s
        }
      }
    })
  end
end
