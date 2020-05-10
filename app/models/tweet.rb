class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  validates :body, presence: true, length: { maximum: 140 }
end
