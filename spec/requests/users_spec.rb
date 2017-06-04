require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user1) { create(:user) }

  describe 'GET /users' do
    context 'without authentication' do
      before(:each) { get users_path }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        token = Knock::AuthToken.new(payload: { sub: user1.id }).token
        get users_path, headers: { authorization: "Bearer #{token}" }
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /users/verify' do
    context 'without authorization' do
      before(:each) { get verify_users_path }

      it "returns 404" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with authentication' do
      before(:each) do
        token = Knock::AuthToken.new(payload: { sub: user1.id }).token
        get verify_users_path, headers: { authorization: "Bearer #{token}" }
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /users/search' do
    let(:params) {
      {
        email: user1.email
      }
    }

    context 'without authorization' do
      before(:each) { get search_users_path, params: params }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        token = Knock::AuthToken.new(payload: { sub: user1.id }).token
        get search_users_path, params: params, headers: { authorization: "Bearer #{token}" }
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'without authentication' do
      before(:each) { get user_path(user1) }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        token = Knock::AuthToken.new(payload: { sub: user1.id }).token
        get user_path(user1), headers: { authorization: "Bearer #{token}" }
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /users' do
    let(:params) { attributes_for(:user).merge!(user_id: user1.to_param) }

    before(:each) do
      token = Knock::AuthToken.new(payload: { sub: user1.id }).token
      post users_path, params: params, headers: { authorization: "Bearer #{token}" }
    end

    it "returns 201" do
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT /users/:id' do
    let(:params) { attributes_for(:user) }

    context 'without authentication' do
      before(:each) { put user_path(user1), params: params }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        token = Knock::AuthToken.new(payload: { sub: user1.id }).token
        put user_path(user1), params: params, headers: { authorization: "Bearer #{token}" }
      end

      it "returns 201" do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
