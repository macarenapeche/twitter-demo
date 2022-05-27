class TweetsChangeColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column :tweets, :user_id, :integer
  end
end
