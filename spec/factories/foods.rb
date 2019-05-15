# frozen_string_literal: true

FactoryBot.define do
  factory :food do
    name { 'test food' }
    notice { 'this is test' }
    amount { 10.5 }
    expiration_date { '2017-01-01' }

    factory :another_food, class: Food do
      name { 'another food' }
    end

    factory :few_left_food, class: Food do
      needs_adding { true }
    end

    trait :with_image do
      file = File.new(File.join('spec', 'resources', 'eggs.jpg'), 'rb')

      image { file }
    end
  end

  factory :no_name_food, class: Food do
    name { '' }
    amount { 10 }
    expiration_date { '2017-01-01' }
  end
end
