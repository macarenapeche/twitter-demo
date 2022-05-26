class Tweet < ApplicationRecord
  validates :content, length: { minimum: 1, maximum: 280 }
  belongs_to :user
end
