class Tweet < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  validates :body, presence: true, length: { maximum: 140 }

  # 違うクラスを作る
  # SQL の Window 関数を使うとランクの番号振りが楽できそう
  # モデルに書いてあるのは good
  def self.yesterday_likes_ranking_top(limit)
    likes_count = Like.where(created_at: Date.yesterday...Date.today)
                      .group(:tweet_id)
                      .order('COUNT(tweet_id) DESC')
                      .count
    rank = 1
    result = []
    likes_count.each.with_index(1) do |(tweet_id, count), index|
      rank = index if result.present? && result.last[:count] > count
      break if rank > limit

      result.push({ tweet: Tweet.find(tweet_id), rank: rank, count: count })
    end
    result
  end
end
