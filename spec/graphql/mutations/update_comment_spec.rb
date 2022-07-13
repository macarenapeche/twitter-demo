RSpec.describe Mutations::UpdateComment do
  include_context "when user exists"
  include_context "when tweet exists"
  subject(:response) { Schema.execute(mutation, variables: variables) }
  let!(:mutation) {<<~GRAPHQL}
    mutation($id: ID!, $content: String, $userId: ID, $tweetId: ID) {
      updateComment(id: $id, content: $content, userId: $userId, tweetId: $tweetId) {
        success
        errors
        comment {
          id
          content
          userId
          tweetId
        }
      }
    }
  GRAPHQL
  let!(:another_user) { User.create(name: "user", handle: "handle", email: "email@gmail.com", password: "password") }

  context "when comment exists" do
    
  end
end
