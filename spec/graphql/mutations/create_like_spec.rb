RSpec.describe Mutations::CreateLike do
  include_context "when user exists"
  include_context "when tweet exists"
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:mutation) { <<~GRAPHQL }
    mutation($tweetId: ID!, $userId: ID!) {
      createLike(tweetId: $tweetId, userId: $userId) {
        success
        errors
        like {
          id
          tweetId
          userId
        }
      }
    }
  GRAPHQL
  let!(:another_user) { User.create(name: "user", handle: "handle", email: "email@gmail.com") }

  context "when input is valid" do
    let!(:variables) { {tweetId: tweet.id, userId: another_user.id } }

    it "returns the correct data" do
      expect(response).to match({
        "data" => {
          "createLike" => {
            "success" => true, 
            "errors" => [],
            "like" => hash_including({
              "tweetId" => tweet.id.to_s,
              "userId" => another_user.id.to_s
            })
          }
        }
      })
    end

    it "increases the number of likes" do
      expect{ response }.to change(Like, :count).by(1)
    end
  end

  context  "when input is invalid" do
    let!(:variables) { {tweetId: tweet.id, userId: 0} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "createLike" => {
            "success" => false, 
            "errors" => [
              "User must exist"
            ],
            "like" => nil
          }
        }
      }) 
    end

    it "doesn't change the number of likes" do
      expect{response}.not_to change(Like, :count)
    end
  end
end
