class LikeSerializer < ActiveModel::Serializer
  attributes :id, :tweet_id, :user_id, :user_handle, :created_at, :updated_at 

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end

  def user_handle
    User.find(object.user_id).handle
  end
end
