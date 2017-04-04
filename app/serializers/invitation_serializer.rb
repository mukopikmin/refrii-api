class InvitationSerializer < ActiveModel::Serializer
  attributes :id, :box_id, :user_id, :created_at, :updated_at

  # belongs_to :box
  # belongs_to :user
end
