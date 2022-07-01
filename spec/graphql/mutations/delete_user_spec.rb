RSpec.describe Mutations::DeleteUser do
  subject(:response) { Schema.execute(mutation, variables: variables).to_h }
  let!(:mutation) { <<~GRAPHQL }
    mutation($id: ID!) {
      deleteUser(id: $id) {
        success
        errors
        user {
          id
          name
          handle
          email
          bio
        }
      }
    }
  GRAPHQL


  context "when ID is valid" do
    include_context "when user exists"
    let!(:variables) { {id: user.id} }

    it "returns the correct data" do
      expect(response).to eq({
        "data" => {
          "deleteUser" => {
            "success" => true,
            "errors" => [],
            "user" => {
              "id" => user.id.to_s,
              "name" => user.name,
              "handle" => user.handle,
              "email" => user.email,
              "bio" => user.bio
            }
          }
        }
      })
    end

    it "deletes the user" do
      expect{ response }.to change(User, :count).by(-1)
    end
  end

  context "when ID is invalid" do
    let!(:variables) { {id: 0} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "deleteUser" => {
            "success" => false, 
            "errors" => [
              "Couldn't find User with 'id'=0"
            ],
            "user" => nil
          }
        }
      })
    end

    it "doesn't delete any user" do
      expect{ response }.not_to change(User, :count)
    end
  end
end
