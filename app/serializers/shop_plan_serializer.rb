# frozen_string_literal: true

class ShopPlanSerializer < ActiveModel::Serializer
  attributes :id,
             :notice,
             :done,
             :amount,
             :created_at,
             :updated_at
end
