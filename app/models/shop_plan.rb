# frozen_string_literal: true

class ShopPlan < ApplicationRecord
  belongs_to :food

  def self.all_with_invited(user)
    Food.all_with_invited(user).map(&:shop_plans).flatten
  end

  def accessible_for?(user)
    food.box.accessible_for?(user)
  end
end
