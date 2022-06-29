module Mutations
  class CreateComment < GraphQL::Schema::Mutation 
    argument :content, String, required: true
    argument :user_id, ID, required: true
    argument :tweet_id, ID, required: true

    field :success, Boolean, null: false 
    field :errors, [String], null: false
    field :comment, Types::CommentType

    def resolve(args)
      comment = Comment.new(args.to_h)
      success = comment.save
      {
        success: success,
        errors: comment.errors.full_messages,
        comment: success ? comment : nil
      }
    end
  end
end
