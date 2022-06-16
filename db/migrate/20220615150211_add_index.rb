class AddIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :follows, [:user_id, :follower_id], unique: true
  end
end
