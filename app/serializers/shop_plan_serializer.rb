# frozen_string_literal: true

class ShopPlanSerializer < ApplicationRecordSerializer
  attributes :id,
             :notice,
             :done,
             :date,
             :amount,
             :created_at,
             :updated_at

  belongs_to :food
end
