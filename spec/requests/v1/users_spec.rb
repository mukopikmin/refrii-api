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
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with admin user' do
        subject { response.status }

        let(:admin) { create(:admin_user) }

        before { get v1_users_path, headers: { authorization: "Bearer #{token(admin)}" } }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with non-admin user' do
        subject { response.status }

        before { get v1_users_path, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(403) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'GET /users/verify' do
    context 'without authorization' do
      context 'without token' do
        subject { response.status }

        before { get verify_v1_users_path }

        it { is_expected.to eq(401) }
        it { assert_schema_conform }
      end

      context 'with non existing user' do
        subject { response.status }

        let(:user) { create(:user) }

        before do
          allow_any_instance_of(V1::UsersController)
            .to receive(:current_user)
            .and_return(nil)
          get verify_v1_users_path, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
      end
    end

    context 'with authentication' do
      subject { response.status }

      before { get verify_v1_users_path, headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'GET /users/search' do
    let(:params) { { email: user1.email } }

    context 'without authorization' do
      subject { response.status }

      before { get search_v1_users_path, params: params }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      before { get search_v1_users_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'GET /users/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_user_path(user1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      before { get v1_user_path(user1), headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'POST /users/google' do
    context 'with valid params' do
      subject { response.status }

      let(:params) do
        {
          email: 'test@test.com',
          name: 'test',
          avatar_url: nil
        }
      end

      before do
        allow_any_instance_of(V1::UsersController)
          .to receive(:google_signup_params)
          .and_return(params)
        post google_v1_users_path
      end

      it { is_expected.to eq(201) }
      it { assert_schema_conform }
    end

    context 'with no email user' do
      subject { response.status }

      let(:params) do
        {
          email: nil,
          name: 'test',
          avatar_url: nil
        }
      end

      before do
        allow_any_instance_of(V1::UsersController)
          .to receive(:google_signup_params)
          .and_return(params)
        post google_v1_users_path
      end

      it { is_expected.to eq(400) }
      it { assert_schema_conform }
    end

    context 'with no name user' do
      subject { response.status }

      let(:params) do
        {
          email: 'test@test.com',
          name: nil,
          avatar_url: nil
        }
      end

      before do
        allow_any_instance_of(V1::UsersController)
          .to receive(:google_signup_params)
          .and_return(params)
        post google_v1_users_path
      end

      it { is_expected.to eq(400) }
      it { assert_schema_conform }
    end

    context 'with existing user' do
      subject { response.status }

      let(:params) do
        {
          email: user.email,
          name: user.name,
          avatar_url: nil
        }
      end
      let(:user) { create(:user) }

      before do
        allow_any_instance_of(V1::UsersController)
          .to receive(:google_signup_params)
          .and_return(params)
        post google_v1_users_path
      end

      before do
        post google_v1_users_path, params: params
      end

      it { is_expected.to eq(400) }
      it { assert_schema_conform }
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
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with valid params' do
        subject { response.status }

        before do
          put v1_user_path(user1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with no name user' do
        subject { response.status }

        before { put v1_user_path(user1), params: no_name_user, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'POST /users/:id/push_token' do
    context 'without authentication' do
      subject { response.status }

      let(:user) { create(:user) }

      before { post push_token_v1_user_path(user) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with user self' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:params) { { token: 'this is dummy token' } }

        before { post push_token_v1_user_path(user), params: params, headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(201) }
        it { assert_schema_conform }
      end

      context 'with other user' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:other) { create(:user) }
        let(:params) { { token: 'this is dummy token' } }

        before { post push_token_v1_user_path(other), params: params, headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(403) }
        it { assert_schema_conform }
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
        it { assert_schema_conform }
      end

      context 'with multiple tokens for a user' do
        subject { response.status }

        let(:user) { create(:user) }
        let(:params1) { { token: 'this is first dummy token' } }
        let(:params2) { { token: 'this is second dummy token' } }

        before do
          post push_token_v1_user_path(user), params: params1, headers: { authorization: "Bearer #{token(user)}" }
          post push_token_v1_user_path(user), params: params2, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(201) }
        it { assert_schema_conform }
      end
    end
  end
end
