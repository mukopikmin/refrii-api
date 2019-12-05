# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users/PushTokens', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe 'POST /users/:id/push_tokens' do
    context 'without authentication' do
      subject { response.status }

      let(:user) { create(:user) }

      before { post v1_user_push_tokens_path(user) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with user self' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:params) { { token: 'this is dummy token' } }

        before { post v1_user_push_tokens_path(user), params: params, headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end

      context 'with other user' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:other) { create(:user) }
        let(:params) { { token: 'this is dummy token' } }

        before { post v1_user_push_tokens_path(other), params: params, headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end

      context 'with existing token' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:params) { { token: 'this is dummy token' } }

        before do
          post v1_user_push_tokens_path(user), params: params, headers: { authorization: "Bearer #{token(user)}" }
          post v1_user_push_tokens_path(user), params: params, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with multiple tokens for a user' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:params1) { { token: 'this is first dummy token' } }
        let(:params2) { { token: 'this is second dummy token' } }

        before do
          post v1_user_push_tokens_path(user), params: params1, headers: { authorization: "Bearer #{token(user)}" }
          post v1_user_push_tokens_path(user), params: params2, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
