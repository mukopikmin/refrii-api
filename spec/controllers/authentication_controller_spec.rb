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
