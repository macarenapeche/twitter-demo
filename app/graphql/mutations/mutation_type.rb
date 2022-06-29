module Mutations
  class MutationType < GraphQL::Schema::Object
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :delete_user, mutation: Mutations::DeleteUser
    
    field :create_tweet, mutation: Mutations::CreateTweet
    field :create_like, mutation: Mutations::CreateLike
    field :create_follow, mutation: Mutations::CreateFollow
    field :create_comment, mutation: Mutations::CreateComment
  end
end
