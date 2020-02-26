class LikeSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :post_id, :created

  belongs_to :user
  belongs_to :post

  def created
    object.created_at.strftime('%Y/%m/%d %H:%M')
  end
end
