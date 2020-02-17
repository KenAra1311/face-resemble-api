class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
end
