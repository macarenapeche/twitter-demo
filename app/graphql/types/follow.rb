module Types
  class Follow < GraphQL::Schema::Object
    graphql_name "FollowType"

    field :id, ID, null: false
    field :user_id, ID, null: false
    field :follower_id, ID, null: false
  end
end
