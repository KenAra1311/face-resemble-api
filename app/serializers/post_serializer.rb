class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :image, :file_name, :emotion, :count, :user_id, :username, :created

  belongs_to :user
  has_many :likes

  def username
    object.user.name
  end

  def created
    object.created_at.strftime('%Y/%m/%d %H:%M')
  end
end
