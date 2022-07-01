module Mutations
  class DeleteLike < GraphQL::Schema::Mutation 
    argument :id, ID, required: true

    field :success, Boolean, null: false 
    field :errors, [String], null: false
    field :like, Types::Like, null: true

    def resolve(args)
      like = Like.find(args[:id])
      success = like.destroy
      {
        success: success,
        errors: [],
        like: like 
      }
    rescue ActiveRecord::RecordNotFound => e
      {
        success: false, 
        errors: ["#{e}"],
        like: nil 
      }
    end
  end
end
