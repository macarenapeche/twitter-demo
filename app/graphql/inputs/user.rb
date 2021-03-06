module Inputs 
  class User < GraphQL::Schema::InputObject
    graphql_name "UserInput"
    
    argument :name, String, required: true
    argument :handle, String, required: true
    argument :email, String, required: true
    argument :bio, String, required: false 
    argument :password, String, required: true
  end
end
