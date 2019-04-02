# frozen_string_literal: true

class InvitationSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at

  belongs_to :box
  belongs_to :user
end
