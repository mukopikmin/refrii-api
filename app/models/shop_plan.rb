# frozen_string_literal: true

class ShopPlan < ApplicationRecord
  belongs_to :food

  def self.all_with_invited(user)
    Food.all_with_invited(user).map(&:shop_plans).flatten
  end

  # def self.done(user)
  #   all_with_invited(user).select(&:done)
  # end

  # def self.undone(user)
  #   all_with_invited(user).select { |p| !p.done }
  # end

  def accessible_for?(user)
    food.box.accessible_for?(user)
  end

  def complete
    ActiveRecord::Base.transaction do
      update(done: true)
      food.update(amount: food.amount + amount)
    end
  end
end
