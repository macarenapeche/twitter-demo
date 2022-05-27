class Follow < ApplicationRecord
  validates :user_id, presence: true 
  validates :following_id, presence: true
  
end
