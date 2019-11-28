# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'GET #index' do
    let(:admin) { create(:admin_user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(admin)}"
    end

    it 'assigns all users as @users' do
      get :index
      expect(assigns(:users)).to eq([admin])
    end
  end

  describe 'GET #verify' do
    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    let(:user) { create(:user) }

    it 'assigns signed in user as @user' do
      get :verify
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested user as @user' do
      get :show, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #createwith_google' do
    context 'with valid params' do
      let(:params) do
        {
          email: 'test@test.com',
          name: 'test',
          avatar_url: nil
        }
      end

      before do
        allow_any_instance_of(described_class)
          .to receive(:google_signup_params)
          .and_return(params)
      end

      it 'creates a new User' do
        expect do
          post :create_with_google
        end.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        post :create_with_google
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          email: nil,
          name: 'test',
          avatar_url: nil
        }
      end

      before do
        allow_any_instance_of(described_class)
          .to receive(:google_signup_params)
          .and_return(params)
      end

      it 'assigns a newly created but unsaved user as @user' do
        post :create_with_google
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:params) { { id: user.to_param }.merge!(attributes_for(:updated_user)) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested user as @user' do
      put :update, params: params
      user.reload
      expect(assigns(:user).name).to eq(params[:name])
    end
  end

  describe 'POST #push_token' do
    let(:user) { create(:user) }
    let(:push_token) { 'this is dummy token for push notification' }
    let(:params) { { id: user.to_param }.merge(token: push_token) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested token as @push_token' do
      post :push_token, params: params
      user.reload
      expect(assigns(:push_token).token).to eq(push_token)
    end
  end
end
