module Types
  class UserType < GraphQL::Schema::Object
    field :id, ID, null: false 
    field :name, String, null: false
    field :handle, String, null: false
    field :email, String, null: false 
    field :bio, String
    field :tweets, [Types::TweetType], null: false
    field :tweetCount, Integer, null: false
    field :followersCount, Integer, null: false
    field :followingCount, Integer, null: false

    def tweetCount
      object.tweets.count
    end

    def followersCount
      object.followers.count
    end

    def followingCount
      object.following.count
    end
  end
end
