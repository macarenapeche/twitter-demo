RSpec.describe Mutations::DeleteTweet do
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:mutation) { <<~GRAPHQL }
    mutation($id: ID!) {
      deleteTweet(id: $id){
        success
        errors
        tweet {
          id
          content
          userId
        }
      }
    }
  GRAPHQL

  context "when ID is valid" do
    include_context "when user exists" 
    include_context "when tweet exists"
    let!(:variables) { {id: tweet.id} }

    it "returns the correct data" do
      expect(response).to eq({
        "data" => {
          "deleteTweet" => {
            "success" => true,
            "errors" => [],
            "tweet" => {
              "id" => tweet.id.to_s,
              "content" => tweet.content,
              "userId" => tweet.user_id.to_s
            }
          }
        }
      })
    end

    it "deletes the user" do
      expect { response }.to change(Tweet, :count).by(-1)
    end
  end

  context "when ID is invalid" do
    let!(:variables) { {id: "0"} }

    it "returns an error message" do
      expect(response).to eq({
        "data" => {
          "deleteTweet" => {
            "success" => false, 
            "errors" => [
              "Couldn't find Tweet with 'id'=0"
            ],
            "tweet" => nil
          }
        }
      })
    end
  end
end
