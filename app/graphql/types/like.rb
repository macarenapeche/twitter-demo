module Types
  class Like < GraphQL::Schema::Object
    graphql_name "LikeType" 
    
    field :id, ID, null: false
    field :tweet_id, ID, null: false
    field :user_id, ID, null: false
  end
end
