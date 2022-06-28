module Types
  class QueryType < GraphQL::Schema::Object
    field :users, [Types::UserType], null: false
    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end
    field :tweets, [Types::TweetType], null: false
    field :tweet, Types::TweetType, null: false do
      argument :id, ID, required: true
    end
    field :likes, [Types::LikeType], null: false
    field :like, Types::LikeType, null: false do
      argument :id, ID, required: true
    end
    field :comments, [Types::CommentType], null: false
    field :comment, Types::CommentType, null: false do 
      argument :id, ID, required: true
    end
    field :follows, [Types::FollowType], null: false
    field :follow, Types::FollowType, null: false do 
      argument :id, ID, required: true
    end

    def users
      User.all
    end

    def user(args)
      User.find(args[:id])
    end

    def tweets
      Tweet.all
    end

    def tweet(args)
      Tweet.find(args[:id])
    end

    def likes
      Like.all
    end

    def like(args)
      Like.find(args[:id])
    end

    def comments
      Comment.all
    end

    def comment(args)
      Comment.find(args[:id])
    end

    def follows
      Follow.all
    end

    def follow(args)
      Follow.find(args[:id])
    end
  end
end
