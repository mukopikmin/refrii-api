# frozen_string_literal: true

class NoticeSerializer < ApplicationRecordSerializer
  attributes :id,
             :text,
             :created_at,
             :updated_at

  belongs_to :created_user
end
