class AddImagesToTweet < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :images, :json
  end
end
