module Mutations
  class CreateUser < GraphQL::Schema::Mutation
    argument :name, String, required: true
    argument :handle, String, required: true
    argument :email, String, required: true
    argument :bio, String, required: false 

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :user, Types::UserType

    def resolve(args)
      user = User.new(args.to_h)
      success = user.save
      {
        success: success,
        errors: user.errors.full_messages, 
        user: success ? user : nil
      }
    end
  end
end
