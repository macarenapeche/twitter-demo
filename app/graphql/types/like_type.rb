module Types
  class LikeType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :tweet_id, ID, null: false
    field :user_id, ID, null: false
  end
end
