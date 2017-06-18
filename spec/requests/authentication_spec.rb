require 'rails_helper'

RSpec.describe "Authenticaion", type: :request do
  let(:params) { attributes_for(:user) }
  let!(:user) { User.create(params) }

  describe 'POST /auth/local' do
    context 'with valid credentials' do
      before(:each) { post auth_local_path, params: params }

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      before(:each) do
        params[:password] = "INVALID #{params[:password]}"
        post auth_local_path, params: params
      end

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /auth/google/callback' do
    it "returns 200" do
      OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
        provider: 'google',
        uid: user.id,
        info: {
          name: params[:name],
          email: params[:email]
        }
      })
      get auth_google_callback_path, headers: { 'omniauth.auth': OmniAuth.config.mock_auth[:google] }
      expect(response).to have_http_status(:ok)
    end
  end
end
