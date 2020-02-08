# frozen_string_literal: true

FactoryBot.define do
  factory :box do
    sequence(:name) { |n| "box #{n}" }
    notice { 'this is box for test' }

    trait :with_owner do
      owner { create(:user) }
    end
  end

  factory :another_box, class: 'Box' do
    name { 'another box' }
    notice { 'this is another box' }
  end

  factory :no_name_box, class: 'Box' do
    notice { 'this box has no name' }
  end
end
