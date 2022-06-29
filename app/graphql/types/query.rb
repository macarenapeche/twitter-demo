module Types
  class Query < GraphQL::Schema::Object
    field :users, [Types::User], null: false
    field :user, Types::User, null: false do
      argument :id, ID, required: true
    end
    field :tweets, [Types::Tweet], null: false
    field :tweet, Types::Tweet, null: false do
      argument :id, ID, required: true
    end
    field :likes, [Types::Like], null: false
    field :like, Types::Like, null: false do
      argument :id, ID, required: true
    end
    field :comments, [Types::Comment], null: false
    field :comment, Types::Comment, null: false do 
      argument :id, ID, required: true
    end
    field :follows, [Types::Follow], null: false
    field :follow, Types::Follow, null: false do 
      argument :id, ID, required: true
    end

    def users
      ::User.all
    end

    def user(args)
      ::User.find(args[:id])
    end

    def tweets
      ::Tweet.all
    end

    def tweet(args)
      ::Tweet.find(args[:id])
    end

    def likes
      ::Like.all
    end

    def like(args)
      ::Like.find(args[:id])
    end

    def comments
      ::Comment.all
    end

    def comment(args)
      ::Comment.find(args[:id])
    end

    def follows
      ::Follow.all
    end

    def follow(args)
      ::Follow.find(args[:id])
    end
  end
end
