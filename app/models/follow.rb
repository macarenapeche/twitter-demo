class Follow < ApplicationRecord
  validates :user_id, presence: true 
  validates :follower_id, presence: true
  validates_uniqueness_of :follower_id, scope: :user_id
  validate :not_following_self

  belongs_to :user, class_name: "User"
  belongs_to :follower, class_name: "User"

  private 

  def not_following_self
    return unless self.user_id == self.follower_id
      
    self.errors.add :user_id, "can't follow himself"
  end
end
