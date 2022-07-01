RSpec.describe Mutations::DeleteFollow do
  include_context "when user exists"
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:mutation) {<<~GRAPHQL}
    mutation($id: ID!) {
      deleteFollow(id: $id) {
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
  
  context "when follow exists" do
    let!(:follow) { Follow.create(user_id: user.id, follower_id: follower.id) }
    let!(:variables) { {id: follow.id} }

    it "returns the correct data" do
      expect(response).to eq({
        "data" => {
          "deleteFollow" => {
            "success" => true,
            "errors" => [],
            "follow" => {
              "id" => follow.id.to_s,
              "userId" => follow.user_id.to_s, 
              "followerId" => follow.follower_id.to_s
            }
          }
        }
      })
    end

    it "decreases the number of follows" do
      expect { response }.to change(Follow, :count).by(-1)
    end
  end

  context "when follow doesn't exists" do
    let!(:variables) { {id: 0} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "deleteFollow" => {
            "success" => false,
            "errors" => [
              "Couldn't find Follow with 'id'=0"
            ],
            "follow" => nil
          }
        }
      })
    end

    it "doesn't decrease the number of follows" do
      expect { response }.not_to change(Follow, :count)
    end
  end
end
