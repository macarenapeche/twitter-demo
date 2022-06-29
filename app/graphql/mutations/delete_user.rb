module Mutations
  class DeleteUser < GraphQL::Schema::Mutation 
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :user, Types::User, null: true

    def resolve(args)
      user = User.find(args[:id])
      success = user.destroy
      {
        success: success,
        errors: [],
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
