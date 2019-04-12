# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe 'GET /users' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_users_path }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with admin user' do
        let(:admin) { create(:admin_user) }

        before { get v1_users_path, headers: { authorization: "Bearer #{token(admin)}" } }

        it { assert_schema_conform }
      end

      context 'with non-admin user' do
        subject { response.status }

        before { get v1_users_path, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(403) }
      end
    end
  end

  describe 'GET /users/verify' do
    context 'without authorization' do
      subject { response.status }

      before { get verify_v1_users_path }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      before { get verify_v1_users_path, headers: { authorization: "Bearer #{token(user1)}" } }

      it { assert_schema_conform }
    end
  end

  describe 'GET /users/search' do
    let(:params) { { email: user1.email } }

    context 'without authorization' do
      subject { response.status }

      before { get search_v1_users_path, params: params }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      before { get search_v1_users_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

      it { assert_schema_conform }
    end
  end

  describe 'GET /users/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_user_path(user1) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      before { get v1_user_path(user1), headers: { authorization: "Bearer #{token(user1)}" } }

      it { assert_schema_conform }
    end
  end

  describe 'GET /users/:id/avatar' do
    let(:user) { create(:user, :with_avatar) }
    let(:no_avatar_user) { create(:user) }

    context 'without authentication' do
      subject { response.status }

      before { get avatar_v1_user_path(user) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with image' do
        subject { response.status }

        before { get avatar_v1_user_path(user), headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(200) }
      end

      context 'with no image' do
        subject { response.status }

        before { get avatar_v1_user_path(no_avatar_user), headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(404) }
      end

      context 'with base64 requested param' do
        subject { response.status }

        before { get avatar_v1_user_path(user), headers: { authorization: "Bearer #{token(user)}" }, params: { base64: true } }

        it { is_expected.to eq(200) }
      end
    end
  end

  describe 'POST /users' do
    context 'with valid params' do
      let(:params) { attributes_for(:user) }

      before { post v1_users_path, params: params }

      it { assert_schema_conform }
    end

    context 'with no email user' do
      subject { response.status }

      let(:params) { attributes_for(:no_email_user) }

      before { post v1_users_path, params: params }

      it { is_expected.to eq(400) }
    end

    context 'with no name user' do
      subject { response.status }

      let(:params) { attributes_for(:no_name_user) }

      before { post v1_users_path, params: params }

      it { is_expected.to eq(400) }
    end
  end

  describe 'PUT /users/:id' do
    let(:params) { attributes_for(:user) }
    let(:inused_params) do
      cloned = params.dup
      cloned[:email] = user2.email

      cloned
    end
    let(:no_email_user) { attributes_for(:no_email_user) }
    let(:no_name_user) { attributes_for(:no_name_user) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_user_path(user1), params: params }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with valid params' do
        before do
          put v1_user_path(user1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { assert_schema_conform }
      end

      context 'with already used email' do
        subject { response.status }

        before { put v1_user_path(user1), params: inused_params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
      end

      context 'with no email user' do
        subject { response.status }

        before { put v1_user_path(user1), params: no_email_user, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
      end

      context 'with no name user' do
        subject { response.status }

        before { put v1_user_path(user1), params: no_name_user, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
      end
    end
  end

  describe 'POST /users/:id/push_token' do
    context 'without authentication' do
      subject { response.status }

      let(:user) { create(:user) }

      before { post push_token_v1_user_path(user) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with user self' do
        let(:user) { create(:user) }
        let(:params) { { token: 'this is dummy token' } }

        before { post push_token_v1_user_path(user), params: params, headers: { authorization: "Bearer #{token(user)}" } }

        it { assert_schema_conform }
      end

      context 'with other user' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:other) { create(:user) }
        let(:params) { { token: 'this is dummy token' } }

        before { post push_token_v1_user_path(other), params: params, headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(403) }
      end

      context 'with existing token' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:params) { { token: 'this is dummy token' } }

        before do
          post push_token_v1_user_path(user), params: params, headers: { authorization: "Bearer #{token(user)}" }
          post push_token_v1_user_path(user), params: params, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(400) }
      end

      context 'with multiple tokens for a user' do
        let(:user) { create(:user) }
        let(:params1) { { token: 'this is first dummy token' } }
        let(:params2) { { token: 'this is second dummy token' } }

        before do
          post push_token_v1_user_path(user), params: params1, headers: { authorization: "Bearer #{token(user)}" }
          post push_token_v1_user_path(user), params: params2, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { assert_schema_conform }
      end
    end
  end
end
