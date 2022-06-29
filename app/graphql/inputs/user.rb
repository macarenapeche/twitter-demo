module Inputs 
  class User < GraphQL::Schema::InputObjects
    graphql_name "UserInput"
    
    argument :name, String, required: true
    argument :handle, String, required: true
    argument :email, String, required: true
    argument :bio, String, required: false 
  end
end
