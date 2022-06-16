class AddForeignKeysToFollows < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :follows, :users 
    add_foreign_key :follows, :followers 
  end
end
