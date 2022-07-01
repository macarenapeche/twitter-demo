RSpec.describe Mutations::UpdateUser do
  include_context "when user exists"
  subject(:response) { Schema.execute(mutation, variables: variables).to_h}
  let!(:mutation) { <<~GRAPHQL }
    mutation($id: ID!, $name: String, $handle: String, $email: String, $bio: String) {
      updateUser(id: $id, name: $name, handle: $handle, email: $email, bio: $bio) {
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
    context "when input is valid" do
      let!(:variables) { {id: user.id.to_s, bio: "BE Intern"} }
  
      it "returns the correct data" do
        expect(response).to eq({
          "data" => {
            "updateUser" => {
              "success" => true,
              "errors" => [],
              "user" => {
                "id" => user.id.to_s,
                "name" => user.name,
                "handle" => user.handle, 
                "email" => user.email,
                "bio" => "BE Intern"
              }
            }
          }
        })
      end
  
      it "changes the user data" do
        expect{ response }.to change{ user.reload.bio }.from(nil).to("BE Intern")
      end
  
      context "when input is invalid" do
        let!(:variables) { { id: user.id.to_s, name: ""} }
        
        it "returns error messages" do
          expect(response).to eq({
            "data" => {
              "updateUser" => {
                "success" => false,
                "errors" => [
                  "Name can't be blank"
                ],
                "user" => {
                  "id" => "1",
                  "name" => "Macarena",
                  "handle" => "mapeciris",
                  "email" => "macarena@toptal.com",
                  "bio" => nil
                }
              }
            }
          })
        end
  
        it "doesn't change the user data" do
          expect{ response }.not_to change{ user.reload.bio }
        end
      end
    end
  end

  context "when ID is invalid" do
    let!(:variables) { {id: 0, name: "Ghost"} }

    it "returns an error" do
      expect(response).to eq({
        "data" => {
          "updateUser" => {
            "success" => false, 
            "errors" => [
              "Couldn't find User with 'id'=0"
            ],
            "user" => nil
          }
        }
      })
    end
  end
end
