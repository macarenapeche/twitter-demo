class Follow < ApplicationRecord
  validates :user_id, presence: true 
  validates :follower_id, presence: true

  belongs_to :user
  belongs_to :follower, class_name: "User"
  
end
