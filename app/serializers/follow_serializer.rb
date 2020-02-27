class FollowSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :follow_id

  belongs_to :user
end
