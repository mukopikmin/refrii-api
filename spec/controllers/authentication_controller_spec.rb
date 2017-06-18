require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  let(:params) { attributes_for(:user) }
  let!(:user) { User.create(params) }

  describe 'POST /auth/local' do
    it 'assigns user as @user' do
      post :local, params: params
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST /auth/google/callback' do
    before(:each) do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: user.id,
        info: {
          name: params[:name],
          email: params[:email]
        }
      })
    end

    it "assigns user as @user" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      get :google
      expect(assigns(:user)).to eq(user)
    end
  end
end
