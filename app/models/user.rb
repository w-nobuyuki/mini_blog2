class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, authentication_keys: [:name]

  has_many :tweets

  validates :name, presence: true,
                   uniqueness: true,
                   length: { maximum: 20 },
                   format: { with: /\A[a-zA-Z]+\z/, allow_blank: true }
  validates :profile, length: { maximum: 200 }

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
