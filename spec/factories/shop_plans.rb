# frozen_string_literal: true

FactoryBot.define do
  factory :shop_plan do
    sequence(:notice) { |n| "sample comment #{n}" }
    done { false }
    date { Date.today }
    amount { rand(0.0..100.0) }
  end

  factory :no_amount_shop_plan, class: ShopPlan do
    sequence(:notice) { |n| "no amount comment #{n}" }
    done { false }
    date { Date.today }
  end
end
