class Follow < ApplicationRecord
  belongs_to :user, foreign_key: 'follow_user_id'
  belongs_to :user, foreign_key: 'follower_id'
  validates :follow_user_id, uniqueness: { scope: :follower_id }
end
