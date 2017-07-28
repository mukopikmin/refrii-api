FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |_n| "#{name}@test.com" }
    password 'secret'
    password_confirmation 'secret'
    disabled false
    admin false

    factory :another_user, class: User do
      name 'another user'
      email 'another@test.com'
    end

    factory :updated_user, class: User do
      email 'new-email@test.com'
    end

    factory :admin_user, class: User do
      admin true
    end

    factory :local_user, class: User do
      provider 'local'
    end

    factory :google_user, class: User do
      provider 'google'
    end

    factory :twitter_user, class: User do
      provider 'twitter'
    end
  end

  factory :no_email_user, class: User do
    name 'no email user'
    email ''
    password 'secret'
    password_confirmation 'secret'
    disabled false
    admin false
  end

  factory :no_name_user, class: User do
    name ''
    email 'noname@test.com'
    password 'secret'
    password_confirmation 'secret'
    disabled false
    admin false
  end

  trait 'with_avatar' do
    file = File.new(File.join('spec', 'resources', 'avatar.jpg'), 'rb')

    avatar_file file
    avatar_size file.size
    avatar_content_type 'image/jpeg'
  end
end
