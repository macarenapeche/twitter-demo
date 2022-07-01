RSpec.describe Mutations::CreateFollow do
  include_context "when user exists"
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:mutation) { <<~GRAPHQL }
    mutation($userId: ID!, $followerId: ID!) {
      createFollow(userId: $userId, followerId: $followerId) {
        success
        errors
        follow {
          id
          userId
          followerId
        }
      }
    }
  GRAPHQL
  let!(:follower) { User.create(name: "follower", handle: "follower", email: "follower@gmail.com") }

  context "when input is valid" do
    let!(:variables) { {userId: user.id, followerId: follower.id } }

    it "returns the correct data" do
      expect(response).to match({
        "data" => {
          "createFollow" => {
            "success" => true, 
            "errors" => [],
            "follow" => hash_including({
              "userId" => user.id.to_s,
              "followerId" => follower.id.to_s
            })
          }
        }
      })
    end

    it "increases the number of follows" do
      expect{ response }.to change(Follow, :count).by(1)
    end
  end

  context  "when input is invalid" do
    let!(:variables) { {userId: user.id, followerId: 0} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "createFollow" => {
            "success" => false, 
            "errors" => [
              "Follower must exist"
            ],
            "follow" => nil
          }
        }
      }) 
    end

    it "doesn't change the number of follows" do
      expect{response}.not_to change(Follow, :count)
    end
  end
end
