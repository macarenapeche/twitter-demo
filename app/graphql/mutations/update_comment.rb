module Mutations
  class UpdateComment < GraphQL::Schema::Mutation 
    argument :id, ID, required: true
    argument :content, String, required: false
    argument :user_id, ID, required: false
    argument :tweet_id, ID, required: false 

    field :success, Boolean, null: false
    field :errors, [String], null: false 
    field :comment, Types::Comment, null: true

    def resolve(args)
      comment = Comment.find(args[:id])
      success = Comment.update(args.to_h)
      {
        success: success,
        errors: comment.errors.full_messages,
        comment: comment.reload
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
