class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :admin, :profile_image, :file_name, :like_total_count

  has_many :posts
  has_many :likes

  def like_total_count
    i = 0
    object.posts.each do |post|
      i += post.count if post.count
    end

    return i
  end
end
