module Mutations
  class DeleteComment < GraphQL::Schema::Mutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :comment, Types::Comment, null: true

    def resolve(args)
      comment = Comment.find(args[:id])
      success = comment.destroy
      {
        success: success,
        errors: [],
        comment: comment
      }
    rescue ActiveRecord::RecordNotFound => e 
      {
        success: false,
        errors: ["#{e}"],
        comment: nil
      }
    end
  end
end
