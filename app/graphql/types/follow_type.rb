module Types
  class FollowType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :user_id, ID, null: false
    field :follower_id, ID, null: false
  end
end
