class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.text :content
      t.string :user_id

      t.timestamps
    end
  end
end
