# frozen_string_literal: true

FactoryBot.define do
  factory :shop_plan do
    notice { 'sample comment' }
    done { false }
    date { Date.today }
    amount { rand(0.0..100.0) }
  end
end
