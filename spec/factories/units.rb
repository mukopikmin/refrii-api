FactoryGirl.define do
  factory :unit do
    sequence(:label) { |n| "label #{n}" }
  end

  factory :updated_unit, class: Unit do
    label 'pack'
  end

  factory :no_label_unit, class: Unit do
    label ''
  end

  trait :with_user do
    user
  end
end
