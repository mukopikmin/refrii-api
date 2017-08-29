require 'rails_helper'

RSpec.describe "Authenticaion", type: :request do
  let(:params) { attributes_for(:user, :with_avatar) }
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
    before(:each) do
      file = File.new(File.join('spec', 'resources', 'avatar.jpg'), 'rb')
      params = {
        file: file,
        size: file.size,
        content_type: 'image/jpeg'
      }
      allow(User).to receive(:download_image).and_return(params)
    end

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

  describe 'GET /auth/google/token' do
    let(:mock_response) do
      open(File.join('spec', 'mocks', 'tokeninfo.json')) do |io|
        JSON.load(io).to_json
      end
    end
    let(:email) { JSON.parse(mock_response)['email'] }
    let(:provider) { 'google' }

    context 'with valid token, existing user' do
      before(:each) do
        response = double
        allow(response).to receive(:code).and_return(200)
        allow(response).to receive(:body).and_return(mock_response)
        allow(RestClient).to receive(:get).and_return(response)
      end
      let(:user) { create(:user, email: email, provider: provider) }
      let(:params) { { token: JsonWebToken.payload(user) } }

      it 'returns 200' do
        get auth_google_token_path, params: params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with valid token, non-existing user' do
      before(:each) do
        response = double
        allow(response).to receive(:code).and_return(200)
        allow(response).to receive(:body).and_return(mock_response)
        allow(RestClient).to receive(:get).and_return(response)
      end
      let(:user) { build(:user, email: email, provider: provider) }
      let(:params) { { token: JsonWebToken.payload(user) } }

      it 'returns 200' do
        get auth_google_token_path, params: params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid token' do
      before(:each) { allow(RestClient).to receive(:get).and_raise(RestClient::ExceptionWithResponse.new) }
      let(:user) { build(:user, email: email, provider: provider) }
      let(:params) { { token: JsonWebToken.payload(user) } }

      it 'returns 400' do
        get auth_google_token_path, params: params
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET /auth/auth0/callback' do
    before(:each) do
      file = File.new(File.join('spec', 'resources', 'avatar.jpg'), 'rb')
      params = {
        file: file,
        size: file.size,
        content_type: 'image/jpeg'
      }
      allow(User).to receive(:download_image).and_return(params)
    end

    it "returns 200" do
      OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
        provider: 'auth0',
        uid: user.id,
        info: {
          name: params[:name],
          email: params[:email]
        },
        extra: {
          raw_info: {
            identities: [
              {
                provider: 'google_oauth2'
              }
            ]
          }
        }
      })
      get auth_auth0_callback_path, headers: { 'omniauth.auth': OmniAuth.config.mock_auth[:auth0] }
      expect(response).to have_http_status(:ok)
    end
  end
end
