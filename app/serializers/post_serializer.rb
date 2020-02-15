class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :image, :file_name, :emotion, :count, :user_id, :username, :created_at

  belongs_to :user
  has_many :likes

  def username
    object.user.name
  end
end
