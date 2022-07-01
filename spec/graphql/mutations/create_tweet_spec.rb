RSpec.describe Mutations::CreateTweet do
  include_context "when user exists"
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:mutation) { <<~GRAPHQL} 
    mutation($content: String!, $userId: ID!) {
      createTweet(content: $content, userId: $userId) {
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

  context "when input is valid" do 
    let!(:variables) { {content: "hello", userId: user.id.to_s} }

    it "returns the correct data" do
      expect(response).to match({
        "data" => {
          "createTweet" => {
            "success" => true, 
            "errors" => [],
            "tweet" => hash_including({
              "content" => "hello",
              "userId" => user.id.to_s
            })
          }
        }
      })
    end

    it "adds a tweet to the database" do
      expect{ response }.to change(Tweet, :count).by(1) 
    end
  end

  context "when input is invalid" do
    let!(:variables) { {content: "hello", userId: "0"} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "createTweet" => {
            "success" => false, 
            "errors" => [
              "User must exist"
            ],
            "tweet" => nil
          }
        }
      })
    end
  end
end
