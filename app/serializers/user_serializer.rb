class UserSerializer < ActiveModel::Serializer 
  attributes :id, :name, :handle, :email, :created_at, :updated_at, :tweets

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end

  def tweets
    object.tweets
  end
end
