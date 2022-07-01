module Mutations
  class MutationType < GraphQL::Schema::Object
    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :delete_user, mutation: Mutations::DeleteUser
    
    field :create_tweet, mutation: Mutations::CreateTweet
    field :update_tweet, mutation: Mutations::UpdateTweet
    field :delete_tweet, mutation: Mutations::DeleteTweet 
    
    field :create_like, mutation: Mutations::CreateLike
    field :delete_like, mutation: Mutations::DeleteLike
    
    field :create_follow, mutation: Mutations::CreateFollow
    field :delete_follow, mutation: Mutations::DeleteFollow

    field :create_comment, mutation: Mutations::CreateComment
    field :update_comment, mutation: Mutations::UpdateComment
    field :delete_comment, mutation: Mutations::DeleteComment
  end
end
