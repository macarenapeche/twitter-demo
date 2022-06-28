module Types
  class TweetType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :content, String, null: false
    field :user_id, ID, null: false
    field :likes, [Types::LikeType], null: false 
    field :comments, [Types::CommentType], null: false
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
