module Mutations
  class UpdateUser < GraphQL::Schema::Mutation 
    argument :id, ID, required: true
    argument :input, Inputs::User, required: false

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :user, Types::User

    def resolve(args)
      user = User.find(args[:id])
      success = user.update(args)
      {
        success: success,
        errors: user.errors.full_messages, 
        user: user
      }
    rescue ActiveRecord::RecordNotFound => e
      {
        success: false, 
        errors: ["#{e}"],
        user: nil
      }
    end
  end
end
