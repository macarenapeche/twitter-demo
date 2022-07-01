module Mutations
  class DeleteTweet < GraphQL::Schema::Mutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false
    field :tweet, Types::Tweet, null: true

    def resolve(args)
      tweet = Tweet.find(args[:id])
      success = tweet.destroy
      { 
        success: success,
        errors: [],
        tweet: tweet
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
