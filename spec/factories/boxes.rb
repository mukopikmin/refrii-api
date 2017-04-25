FactoryGirl.define do
  factory :box do
    sequence(:name) { |n| "box #{n}" }
    notice 'this is box for test'
  end

  factory :another_box, class: Box do
    name 'another box'
    notice 'this is another box'
  end

  factory :no_name_box, class: Box do
    notice 'this box has no name'
  end
end
