class TweetSerializer < ActiveModel::Serializer 
  attributes :id, :content, :user_id, :author, :created_at, :updated_at

  def author
    User.find(object.user_id).handle
  end

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end
