module Types
  class Tweet < GraphQL::Schema::Object
    graphql_name "TweetType"

    field :id, ID, null: false
    field :content, String, null: false
    field :user_id, ID, null: false
    field :likes, [Types::Like], null: false 
    field :comments, [Types::Comment], null: false
    field :likeCount, Integer, null: false
    field :commentCount, Integer, null: false

    def likeCount
      object.likes.count
    end

    def commentCount
      object.comments.count
    end
  end
end
