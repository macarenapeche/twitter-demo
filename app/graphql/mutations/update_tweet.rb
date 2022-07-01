module Mutations
  class UpdateTweet < GraphQL::Schema::Mutation
    argument :id, ID, required: true
    argument :content, String, required: false
    argument :user_id, ID, required: false 

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :tweet, Types::Tweet, null: true

    def resolve(args)
      tweet = Tweet.find(args[:id])
      success = tweet.update(args)
      {
        success: success,
        errors: tweet.errors.full_messages,
        tweet: tweet.reload
      }
    rescue ActiveRecord::RecordNotFound => e
      {
        success: false,
        errors: ["#{e}"],
        tweet: nil 
      }
    end
  end
end
