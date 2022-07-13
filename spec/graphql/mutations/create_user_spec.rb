RSpec.describe Mutations::CreateUser do
  subject(:response) { Schema.execute(mutation, variables: variables).to_h}
  let!(:mutation) { <<~GRAPHQL }
    mutation($input: UserInput!) {
      createUser(input: $input) {
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
  let!(:variables) { {input: {name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com", password: "password"}} }

  context "when input is valid" do
    it "returns the correct data" do
      expect(response).to match({
        "data" => {
          "createUser" => {
            "success" => true,
            "errors" => [],
            "user" => hash_including({
              "name" => "Macarena",
              "handle" => "mapeciris", 
              "email" => "macarena@toptal.com",
              "bio" => nil
            })
          }
        }
      })
    end

    it "adds a new user to the database" do
      expect{ response }.to change(User, :count).by(1)
    end

    context "when input is invalid" do
      include_context "when user exists"
      
      it "returns error messages" do
        expect(response).to eq({
          "data" => {
            "createUser" => {
              "success" => false, 
              "errors" => [
                "Handle has already been taken",
                "Email has already been taken"
              ],
              "user" => nil
            }
          }
        })
      end

      it "doesn't add a new user to the database" do
        expect{ response }.not_to change(User, :count)
      end
    end
  end
end
