# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |_n| "#{name}@test.com" }
    disabled { true }
    admin { false }

    factory :another_user, class: 'User' do
      name { 'another user' }
      email { 'another@test.com' }
    end

    factory :updated_user, class: 'User' do
      name { 'new-name' }
    end

    factory :admin_user, class: 'User' do
      admin { true }
    end

    factory :local_user, class: 'User' do
      provider { 'local' }
    end

    factory :google_user, class: 'User' do
      provider { 'google' }
    end

    factory :twitter_user, class: 'User' do
      provider { 'twitter' }
    end
  end

  factory :no_email_user, class: 'User' do
    name { 'no email user' }
    email { '' }
    disabled { false }
    admin { false }
  end

  factory :no_name_user, class: 'User' do
    name { '' }
    email { 'noname@test.com' }
    disabled { false }
    admin { false }
  end

  trait 'with_avatar' do
    file = File.new(File.join('spec', 'resources', 'avatar1.jpg'), 'rb')

    avatar { file }
  end
end
