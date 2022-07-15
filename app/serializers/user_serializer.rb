class UserSerializer < ActiveModel::Serializer 
  # REVIEW: password_digest is a BIG secret, we don't expose it
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
