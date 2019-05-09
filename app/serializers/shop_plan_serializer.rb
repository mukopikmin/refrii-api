# frozen_string_literal: true

class ShopPlanSerializer < ActiveModel::Serializer
  attributes :id,
             :notice,
             :done,
             :date,
             :amount,
             :created_at,
             :updated_at

  belongs_to :food
end
