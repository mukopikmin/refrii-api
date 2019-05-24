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

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, params: attributes_for(:user)
        end.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        post :create, params: attributes_for(:user)
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user as @user' do
        post :create, params: attributes_for(:no_email_user)
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).not_to be_persisted
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested user as @user' do
      put :update, params: { id: user.to_param }.merge!(attributes_for(:updated_user))
      user.reload
      expect(assigns(:user).email).to eq(build(:updated_user).email)
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
