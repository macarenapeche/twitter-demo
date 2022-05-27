class Follow < ApplicationRecord
  validates :user_id, presence: true 
  validates :follower_id, presence: true

  belong_to :user
  belong_to :follower, class_name: "User"
  
end
