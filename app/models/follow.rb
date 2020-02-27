class Follow < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :follow_id, scope: :user_id
end
