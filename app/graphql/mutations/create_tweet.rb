module Mutations 
  class CreateTweet < GraphQL::Schema::Mutation 
    argument :content, String, required: true
    argument :user_id, ID, required: true

    field :success, Boolean, null: false 
    field :errors, [String], null: false
    field :tweet, Types::Tweet

    def resolve(args)
      tweet = Tweet.new(args.to_h)
      success = tweet.save
      {
        success: success,
        errors: tweet.errors.full_messages,
        tweet: success ? tweet : nil
      }
    end
  end
end
