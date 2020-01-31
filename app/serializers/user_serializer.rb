class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :admin, :profile_image
  has_many :posts
end
