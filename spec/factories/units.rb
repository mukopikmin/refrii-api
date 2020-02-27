# frozen_string_literal: true

FactoryBot.define do
  factory :unit do
    sequence(:label) { |n| "label #{n}" }
    sequence(:step) { |n| n }

    trait :with_user do
      user { create(:user) }
    end

    trait :with_negative_step do
      step { -10 }
    end

    trait :with_zero_step do
      step { 0 }
    end

    trait :with_empty_label do
      label { '' }
      step { 10 }
    end
  end

  factory :no_label_unit, class: 'Unit' do
    step { 10 }
  end

  factory :no_step_unit, class: 'Unit' do
    sequence(:label) { |n| "label #{n}" }
  end
end
