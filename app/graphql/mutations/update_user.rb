module Mutations
  class UpdateUser < GraphQL::Schema::Mutation 
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :handle, String, required: false
    argument :email, String, required: false
    argument :bio, String, required: false

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :user, Types::UserType

    def resolve(args)
      user = User.find(args[:id])
      success = user.update(args)
      {
        success: success,
        errors: user.errors.full_messages, 
        user: user
      }
    end
  end
end
