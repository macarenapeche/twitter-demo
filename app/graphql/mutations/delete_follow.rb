module Mutations
  class DeleteFollow < GraphQL::Schema::Mutation 
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :follow, Types::Follow, null: true

    def resolve(args)
      follow = Follow.find(args[:id])
      success = follow.destroy
      {
        success: success, 
        errors: [], 
        follow: follow 
      }
    rescue ActiveRecord::RecordNotFound => e
      {
        success: false, 
        errors: ["#{e}"],
        follow: nil
      }
    end
  end
end
