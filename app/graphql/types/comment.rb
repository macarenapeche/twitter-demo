module Types
  class Comment < GraphQL::Schema::Object
    graphql_name "CommentType"
    
    field :id, ID, null: false
    field :content, String, null: false
    field :user_id, ID, null: false
    field :tweet_id, ID, null: false
  end
end
