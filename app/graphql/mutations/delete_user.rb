module Mutations
  class DeleteUser < GraphQL::Schema::Mutation 
    argument :id, ID, required: true

    field :id, ID, null: false
    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id: nil)
      user = User.find(id)
      user.destroy
      {
        id: id
      }
    end
  end
end
