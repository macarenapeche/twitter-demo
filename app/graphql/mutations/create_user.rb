module Mutations
  class CreateUser < GraphQL::Schema::Mutation
    argument :input, Inputs::User, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :user, Types::User

    def resolve(args)
      user = User.new(args[:input].to_h)
      success = user.save
      {
        success: success,
        errors: user.errors.full_messages, 
        user: success ? user : nil
      }
    end
  end
end
