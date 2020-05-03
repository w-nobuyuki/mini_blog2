class Follow < ApplicationRecord
  belongs_to :follow_user, class_name: 'User', foreign_key: 'follow_user_id'
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  validates :follow_user_id, uniqueness: { scope: :follower_id }
end
