class TweetSerializer < ActiveModel::Serializer 
  attributes :id, :content, :user_id, :created_at, :updated_at

  has_one :author, serializer: UserSerializer
  has_many :likes

  def author
    object.user
  end

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end
