class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :admin, :profile_image, :file_name
  
  has_many :posts
  has_many :likes
end
