class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :tweet, null: false, foreign_key: true, index: false

      t.timestamps
    end
    add_index :likes, %i[tweet_id user_id], unique: true
  end
end
