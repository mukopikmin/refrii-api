# frozen_string_literal: true

FactoryBot.define do
  factory :notice do
    text { 'notice text' }

    trait :with_food do
      food { create(:food, :with_box_user_unit) }
      created_user { food.box.owner }
      updated_user { food.box.owner }
    end
  end
end
