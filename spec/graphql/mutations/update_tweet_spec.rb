RSpec.describe Mutations::UpdateTweet do
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:mutation) { <<~GRAPHQL }
    mutation($id: ID!, $content: String, $userId: ID) {
      updateTweet(id: $id, content: $content, userId: $userId) {
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

  context "when tweet exists" do
    include_context "when user exists"
    include_context "when tweet exists" 

    context "when input is valid" do
      let(:variables) { {id: tweet.id, content: "edited"} }

      it "returns the correct data" do
        expect(response).to eq({
          "data" => {
            "updateTweet" => {
              "success" => true, 
              "errors" => [],
              "tweet" => {
                "id" => tweet.id.to_s,
                "content" => "edited", 
                "userId" => tweet.user_id.to_s
              }
            }
          }
        })
      end

      it "changes the tweet data" do
        expect{ response }.to change{ tweet.reload.content }.to("edited")
      end
    end
    
    context "when input is invalid" do
      let(:variables) { {id: tweet.id, content: ""} }

      it "returns an error" do
        expect(response).to eq({
          "data" => {
            "updateTweet" => {
              "success" => false, 
              "errors" => [
                "Content can't be blank"
              ],
              "tweet" => {
                "id" => tweet.id.to_s,
                "content" => tweet.content, 
                "userId" => tweet.user_id.to_s
              }
            }
          }
        })
      end

      it "doesn't change the tweet data" do
        expect{ response }.not_to change{ tweet.reload.content }
      end
    end
  end
end
