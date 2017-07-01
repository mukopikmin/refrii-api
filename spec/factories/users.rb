FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |_n| "#{name}@test.com" }
    password 'secret'
    password_confirmation 'secret'
    disabled false

    factory :another_user, class: User do
      name 'another user'
      email 'another@test.com'
    end

    factory :updated_user, class: User do
      email 'new-email@test.com'
    end
  end

  factory :no_email_user, class: User do
    name 'no email user'
    email ''
    password 'secret'
    password_confirmation 'secret'
    disabled false
  end

  factory :no_name_user, class: User do
    name ''
    email 'noname@test.com'
    password 'secret'
    password_confirmation 'secret'
    disabled false
  end
end
