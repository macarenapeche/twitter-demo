class UserSerializer < ActiveModel::Serializer 
  attributes :id, :name, :handle, :email, :password_digest, :bio, :created_at, :updated_at

  has_many :tweets
  has_many :followers
  has_many :following

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end
