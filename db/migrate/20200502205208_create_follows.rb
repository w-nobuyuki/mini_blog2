class CreateFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, index: false, foreign_key: { to_table: :users }
      t.references :follow_user, null: false, index: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :follows, %i[follower_id follow_user_id], unique: true
  end
end
