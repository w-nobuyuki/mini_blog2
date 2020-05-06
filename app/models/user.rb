class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, authentication_keys: [:name]

  has_many :tweets, dependent: :destroy
  has_many :follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :followed, class_name: 'Follow', foreign_key: 'follow_user_id', dependent: :destroy
  has_many :follow_users, through: :follows, source: :follow_user
  has_many :follow_users_tweets, through: :follow_users, source: :tweets
  has_many :likes, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: true,
                   length: { maximum: 20 },
                   format: { with: /\A[a-zA-Z]+\z/, allow_blank: true }
  validates :profile, length: { maximum: 200 }

  def following?(user)
    follow_users.pluck(:follow_user_id).include?(user.id)
  end

  def like_tweet?(tweet_id)
    likes.pluck(:tweet_id).include?(tweet_id)
  end

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
