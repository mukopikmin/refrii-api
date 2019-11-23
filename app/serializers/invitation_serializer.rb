# frozen_string_literal: true

class InvitationSerializer < ApplicationRecordSerializer
  attributes :id,
             :created_at,
             :updated_at

  belongs_to :user
end
