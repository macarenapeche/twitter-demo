module Mutations 
  class CreateLike < GraphQL::Schema::Mutation 
    argument :tweet_id, ID, required: true
    argument :user_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :like, Types::Like

    def resolve(args)
      like = Like.new(args.to_h)
      success = like.save
      {
        success: success,
        errors: like.errors.full_messages,
        like: success ? like : nil
      }
    end
  end
end
