# frozen_string_literal: true

FactoryBot.define do
  factory :push_token do
    sequence(:token) { |n| "dummy token #{n}" }
  end
end
