# frozen_string_literal: true

FactoryBot.define do
  factory :food do
    name { 'test food' }
    amount { 10.5 }
    expiration_date { '2017-01-01' }

    factory :another_food, class: 'Food' do
      name { 'another food' }
    end

    trait :with_image do
      path = File.join('spec', 'resources', 'eggs.jpg')

      image do
        {
          io: File.open(path, 'rb'),
          filename: File.basename(path),
          content_type: 'image/jpeg'
        }
      end
    end
  end

  factory :no_name_food, class: 'Food' do
    name { '' }
    amount { 10 }
    expiration_date { '2017-01-01' }
  end
end
