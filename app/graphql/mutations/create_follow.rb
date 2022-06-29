module Mutations
  class CreateFollow < GraphQL::Schema::Mutation 
    argument :user_id, ID, required: true
    argument :follower_id, ID, required: true

    field :success, Boolean, null: false 
    field :errors, [String], null: false
    field :follow, Types::FollowType

    def resolve(args)
      follow = Follow.new(args.to_h)
      success = follow.save
      {
        success: success,
        errors: follow.errors.full_messages,
        follow: success ? follow : nil
      }
    end
  end
end
