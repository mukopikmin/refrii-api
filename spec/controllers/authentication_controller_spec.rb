require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do

  describe 'POST /auth/local' do
    let(:params) { attributes_for(:user, :with_avatar) }
    let!(:user) { User.create(params) }

    it 'assigns user as @user' do
      post :local, params: params
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST /auth/google/callback' do
    let(:params) { attributes_for(:google_user, :with_avatar) }
    let!(:user) { User.create(params) }

    before(:each) do
      file = File.new(File.join('spec', 'resources', 'avatar.jpg'), 'rb')
      params = {
        file: file,
        size: file.size,
        content_type: 'image/jpeg'
      }
      allow(User).to receive(:download_image).and_return(params)
    end

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
      expect(assigns(:user).id).to eq(user.id)
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
      before(:each) { get :google_token, params: params }

      it 'assigns user as @user' do
        expect(assigns(:user).id).to eq(user.id)
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
      before(:each) { get :google_token, params: params }

      it 'assigns user as @user' do
        expect(assigns(:user).email).to eq(user.email)
      end
    end

    context 'with invalid token' do
      before(:each) { allow(RestClient).to receive(:get).and_raise(RestClient::ExceptionWithResponse.new) }
      let(:user) { build(:user, email: email, provider: provider) }
      let(:params) { { token: JsonWebToken.payload(user) } }
      before(:each) { get :google_token, params: params }

      it 'assigns nil as @user' do
        expect(assigns(:user)).to be_nil
      end
    end
  end

  describe 'POST /auth/auth0/callback' do
    let(:params) { attributes_for(:google_user, :with_avatar, provider: 'auth0/google_oauth2') }
    let!(:user) { User.create(params) }

    before(:each) do
      file = File.new(File.join('spec', 'resources', 'avatar.jpg'), 'rb')
      params = {
        file: file,
        size: file.size,
        content_type: 'image/jpeg'
      }
      allow(User).to receive(:download_image).and_return(params)
    end

    before(:each) do
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
    end

    it "assigns user as @user" do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:auth0]
      get :auth0
      expect(assigns(:user).id).to eq(user.id)
    end
  end
end
