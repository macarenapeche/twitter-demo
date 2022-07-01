RSpec.describe Mutations::DeleteLike do
  include_context "when user exists"
  include_context "when tweet exists"
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:another_user) { User.create(name: "user", handle: "handle", email: "email@gmail.com") }
  let!(:like) { Like.create(tweet_id: tweet.id, user_id: another_user.id) }
  let!(:mutation) {<<~GRAPHQL}
    mutation($id: ID!){
      deleteLike(id: $id) {
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

  context "when input is valid" do
    let!(:variables) { {id: like.id } }

    it "returns the correct data" do
      expect(response).to eq({
        "data" => {
          "deleteLike" => {
            "success" => true, 
            "errors" => [],
            "like" => {
              "id" => like.id.to_s,
              "tweetId" => like.tweet_id.to_s,
              "userId" => like.user_id.to_s
            }
          }
        }
      })
    end

    it "removes the like" do
      expect { response }.to change(Like, :count).by(-1)
    end
  end

  context "when input is invalid" do
    let!(:variables) { {id: 0} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "deleteLike" => {
            "success" => false, 
            "errors" => [
              "Couldn't find Like with 'id'=0"
            ],
            "like" => nil 
          }
        }
      })
    end

    it "doesn't remove any like" do
      expect {response}.not_to change(Like, :count)
    end
  end
end
