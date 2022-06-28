module Types
  class CommentType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :content, String, null: false
    field :user_id, ID, null: false
    field :tweet_id, ID, null: false
  end
end
