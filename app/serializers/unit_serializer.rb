# frozen_string_literal: true

class UnitSerializer < ApplicationRecordSerializer
  attributes :id,
             :label,
             :step,
             :created_at,
             :updated_at

  belongs_to :user
end
