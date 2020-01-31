class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :image, :username
  belongs_to :user

  def username
    object.user.name
  end
end
