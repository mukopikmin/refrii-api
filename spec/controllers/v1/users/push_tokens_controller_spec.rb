# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Users::PushTokensController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:push_token) { 'this is dummy token for push notification' }
    let(:params) { { user_id: user.to_param }.merge(token: push_token) }

    before do
      request.headers['Authorization'] = "Bearer #{token(user)}"
    end

    it 'assigns the requested token as @push_token' do
      post :create, params: params
      user.reload
      expect(assigns(:push_token).token).to eq(push_token)
    end
  end
end
