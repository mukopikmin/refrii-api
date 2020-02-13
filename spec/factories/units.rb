# frozen_string_literal: true

FactoryBot.define do
  factory :unit do
    sequence(:label) { |n| "label #{n}" }

    trait :with_user do
      user { create(:user) }
    end
  end

  factory :updated_unit, class: 'Unit' do
    label { 'pack' }
  end

  factory :no_label_unit, class: 'Unit' do
    label { '' }
  end
end
