require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  def token(user)
    JsonWebToken.payload(user)[:jwt]
  end

  # describe 'GET #index' do
  #   before(:each) do
  #     request.headers['Authorization'] = "Bearer #{token(user)}"
  #   end
  #
  #   let(:user) { create(:user) }
  #
  #   it 'assigns all users as @users' do
  #     get :index
  #     expect(assigns(:users)).to eq([user])
  #   end
  # end

  describe 'GET #verify' do
    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    let(:user) { create(:user) }

    it 'assigns signed in user as @user' do
      get :verify
      expect(assigns(:user)).to eq(user)
    end
  end

  # describe 'GET #show' do
  #   let(:user) { create(:user) }
  #
  #   before(:each) do
  #     request.headers['Authorization'] = "Bearer #{token(user)}"
  #   end
  #
  #   it 'assigns the requested user as @user' do
  #     get :show, params: { id: user.to_param }
  #     expect(assigns(:user)).to eq(user)
  #   end
  # end

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

    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested user as @user' do
      put :update, params: { id: user.to_param }.merge!(attributes_for(:updated_user))
      user.reload
      expect(assigns(:user).email).to eq(build(:updated_user).email)
    end
  end
end
