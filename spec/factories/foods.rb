# frozen_string_literal: true

FactoryBot.define do
  factory :food do
    name { 'test food' }
    amount { 10.5 }
    expiration_date { '2017-01-01' }

    trait :with_box_user_unit do
      box { create(:box, :with_owner) }
      unit { create(:unit, user: box.owner) }
      created_user { box.owner }
      updated_user { box.owner }
    end
  end

  factory :another_food, class: 'Food' do
    name { 'another food' }
  end

  factory :no_name_food, class: 'Food' do
    name { '' }
    amount { 10 }
    expiration_date { '2017-01-01' }
  end
end
