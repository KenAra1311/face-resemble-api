class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true,   length: { maximum: 16 }
  validates :email, presence: true,   length: { maximum: 32 },
                    uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :uid,   presence: true,   length: { in: 6..32 }
end
