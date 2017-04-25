require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  def token(user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  describe 'GET #index' do
    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    let(:user) { create(:user) }

    it 'assigns all users as @users' do
      get :index
      expect(assigns(:users)).to eq([user])
    end
  end

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

  describe 'GET #show' do
    before(:each) do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    let(:user) { create(:user) }

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
      it 'raises error' do
        expect do
          post :create, params: attributes_for(:no_email_user)
        end.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @user = create(:user)
      create(:another_user)
      request.headers['Authorization'] = "Bearer #{token(@user)}"
    end

    context 'with valid params' do
      it 'assigns the requested user as @user' do
        put :update, params: { id: @user.to_param }.merge!(attributes_for(:updated_user))
        @user.reload
        expect(assigns(:user).email).to eq(build(:updated_user).email)
      end
    end

    context 'with existing email' do
      it 'aises error' do
        expect {
          put :update, params: { id: @user.to_param }.merge!(attributes_for(:another_user))
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = create(:user)
      request.headers['Authorization'] = "Bearer #{token(@user)}"
    end

    it 'destroys the requested user' do
      expect do
        delete :destroy, params: { id: @user.to_param }
      end.to change(User, :count).by(-1)
    end
  end
end
