# frozen_string_literal: true

FactoryBot.define do
  factory :shop_plan do
    sequence(:notice) { |n| "sample comment #{n}" }
    done { false }
    date { Date.today }
    amount { rand(0.0..100.0) }

    trait :completed do
      done { true }
    end

    trait :with_negative_amount do
      amount { -10 }
    end
  end

  factory :no_amount_shop_plan, class: 'ShopPlan' do
    sequence(:notice) { |n| "no amount comment #{n}" }
    done { false }
    date { Date.today }
  end

  factory :no_date_shop_plan, class: 'ShopPlan' do
    sequence(:notice) { |n| "no amount comment #{n}" }
    done { false }
    amount { rand(0.0..100.0) }
  end

  factory :no_done_shop_plan, class: 'ShopPlan' do
    sequence(:notice) { |n| "no amount comment #{n}" }
    date { Date.today }
    amount { rand(0.0..100.0) }
  end
end
