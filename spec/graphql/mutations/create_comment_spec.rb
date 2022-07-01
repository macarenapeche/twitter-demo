RSpec.describe Mutations::CreateComment do
  include_context "when user exists"
  include_context "when tweet exists"
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:mutation) { <<~GRAPHQL }
    mutation($content: String!, $tweetId: ID!, $userId: ID!) {
      createComment(content: $content, tweetId: $tweetId, userId: $userId) {
        success
        errors
        comment {
          id
          content
          tweetId
          userId
        }
      }
    }
  GRAPHQL
  let!(:another_user) { User.create(name: "user", handle: "handle", email: "email@gmail.com") }

  context "when input is valid" do
    let!(:variables) { {content: "comment", tweetId: tweet.id, userId: another_user.id } }

    it "returns the correct data" do
      expect(response).to match({
        "data" => {
          "createComment" => {
            "success" => true, 
            "errors" => [],
            "comment" => hash_including({
              "content" => "comment",
              "tweetId" => tweet.id.to_s,
              "userId" => another_user.id.to_s
            })
          }
        }
      })
    end

    it "increases the number of comments" do
      expect{ response }.to change(Comment, :count).by(1)
    end
  end

  context  "when input is invalid" do
    let!(:variables) { {content: "comment", tweetId: tweet.id, userId: 0} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "createComment" => {
            "success" => false, 
            "errors" => [
              "User must exist"
            ],
            "comment" => nil
          }
        }
      }) 
    end

    it "doesn't change the number of comments" do
      expect{response}.not_to change(Comment, :count)
    end
  end
end
