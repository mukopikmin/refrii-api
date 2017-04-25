FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "user#{n}"}
    sequence(:email) {|n| "#{name}@test.com"}
    password 'secret'
    password_confirmation 'secret'
    admin false
    disabled false

    factory :another_user, class: User do
      name 'another user'
      email 'another@test.com'
    end
  end

  factory :no_email_user, class: User do
    name 'no mail user'
    password 'secret'
    password_confirmation 'secret'
    admin false
    disabled false
  end

  factory :updated_user, class: User do
    email 'new-email@test.com'
  end
end
