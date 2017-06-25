FactoryGirl.define do
  factory :food do
    name 'test food'
    notice 'this is test'
    amount 10.5
    expiration_date '2017-01-01'

    factory :another_food, class: Food do
      name 'another food'
    end
  end

  factory :no_name_food, class: Food do
    name ''
    amount 10
    expiration_date '2017-01-01'
  end
end
