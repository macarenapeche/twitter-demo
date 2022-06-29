module Types
  class User < GraphQL::Schema::Object
    graphql_name "UserType"

    field :id, ID, null: false 
    field :name, String, null: false
    field :handle, String, null: false
    field :email, String, null: false 
    field :bio, String
    field :tweets, [Types::Tweet], null: false
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
