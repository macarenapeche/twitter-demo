RSpec.describe Mutations::DeleteComment do
  include_context "when user exists"
  include_context "when tweet exists"
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:another_user) { User.create(name: "user", handle: "handle", email: "email@gmail.com", password: "password") }
  let!(:comment) { Comment.create(content: "comment", tweet_id: tweet.id, user_id: another_user.id) }
  let!(:mutation) {<<~GRAPHQL}
    mutation($id: ID!){
      deleteComment(id: $id) {
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

  context "when input is valid" do
    let!(:variables) { {id: comment.id } }

    it "returns the correct data" do
      expect(response).to eq({
        "data" => {
          "deleteComment" => {
            "success" => true, 
            "errors" => [],
            "comment" => {
              "id" => comment.id.to_s,
              "content" => comment.content,
              "tweetId" => comment.tweet_id.to_s,
              "userId" => comment.user_id.to_s
            }
          }
        }
      })
    end

    it "removes the comment" do
      expect { response }.to change(Comment, :count).by(-1)
    end
  end

  context "when input is invalid" do
    let!(:variables) { {id: 0} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "deleteComment" => {
            "success" => false, 
            "errors" => [
              "Couldn't find Comment with 'id'=0"
            ],
            "comment" => nil 
          }
        }
      })
    end

    it "doesn't remove any comment" do
      expect {response}.not_to change(Comment, :count)
    end
  end
end
