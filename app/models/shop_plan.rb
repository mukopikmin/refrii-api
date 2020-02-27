# frozen_string_literal: true

class ShopPlan < ApplicationRecord
  belongs_to :food

  validates_presence_of :date
  validates_presence_of :amount
  validates_presence_of :food
  validates_inclusion_of :done, in: [true, false]
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def self.all_with_invited(user)
    Food.all_with_invited(user).map(&:shop_plans).flatten
  end

  def update_or_complete(params)
    if !params[:done].nil? && params[:done] && !done
      ActiveRecord::Base.transaction do
        update(params)
        food.update(amount: food.amount + amount)
      end
    else
      update(params)
    end
  end

  def accessible_for?(user)
    food.box.accessible_for?(user)
  end
end
