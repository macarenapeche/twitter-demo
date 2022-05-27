class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :follows, :following_id, :follower_id
  end
end
