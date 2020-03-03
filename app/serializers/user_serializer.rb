class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :admin, :profile_image, :file_name, :created, :like_total_count

  has_many :posts,    dependent: :destroy
  has_many :likes,    dependent: :destroy
  has_many :follows,  dependent: :destroy
  has_many :comments, dependent: :destroy

  def created
    object.created_at.strftime('%Y/%m/%d')
  end

  def like_total_count
    return 0 unless object.posts

    i = 0
    object.posts.each do |post|
      i += post.count if post.count
    end

    return i
  end
end
