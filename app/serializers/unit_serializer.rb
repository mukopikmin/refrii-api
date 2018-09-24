# frozen_string_literal: true

class UnitSerializer < ActiveModel::Serializer
  attributes :id,
             :label,
             :step,
             :created_at,
             :updated_at

  belongs_to :user
  # has_many :foods
end
