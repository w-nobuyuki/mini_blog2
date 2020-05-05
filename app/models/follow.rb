class Follow < ApplicationRecord
  belongs_to :follow_user, class_name: 'User', foreign_key: 'follow_user_id'
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_id'
  validates :follow_user_id, uniqueness: { scope: :follower_id }
  validate :cannot_follow_myself

  def cannot_follow_myself
    return unless follower_id == follow_user_id

    errors.add(:follow_user_id, 'は自分以外のユーザーを指定してください')
  end
end
