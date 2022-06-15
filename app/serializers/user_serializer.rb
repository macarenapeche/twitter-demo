class UserSerializer < ActiveModel::Serializer 
  attributes :id, :name, :handle, :email, :created_at, :updated_at

  has_many :tweets

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end
