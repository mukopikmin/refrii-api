require 'rails_helper'

RSpec.describe "Users", type: :request do
  def token(user)
    JsonWebToken.payload(user)[:jwt]
  end

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe 'GET /users' do
    context 'without authentication' do
      before(:each) { get users_path }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'by admin user' do
        let(:admin) { create(:admin_user) }

        before(:each) do
          get users_path, headers: { authorization: "Bearer #{token(admin)}" }
        end

        it "returns 200" do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'by non-admin user' do
        before(:each) do
          get users_path, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 403" do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'GET /users/verify' do
    context 'without authorization' do
      before(:each) { get verify_users_path }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        get verify_users_path, headers: { authorization: "Bearer #{token(user1)}" }
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
        get search_users_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
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
        get user_path(user1), headers: { authorization: "Bearer #{token(user1)}" }
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /users' do
    context 'with valid params' do
      let(:params) { attributes_for(:user) }

      before(:each) do
        post users_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it "returns 201" do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with no email user' do
      let(:params) { attributes_for(:no_email_user) }

      before(:each) do
        post users_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it "returns 400" do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'with no name user' do
      let(:params) { attributes_for(:no_name_user) }

      before(:each) do
        post users_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it "returns 400" do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:params) { attributes_for(:user) }
    let(:inused_params) do
      _params = params.dup
      _params[:email] = user2.email
      _params
    end
    let(:no_email_user) { attributes_for(:no_email_user) }
    let(:no_name_user) { attributes_for(:no_name_user) }

    context 'without authentication' do
      before(:each) { put user_path(user1), params: params }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with valid params' do
        before(:each) do
          put user_path(user1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 201" do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with already used email' do
        before(:each) do
          put user_path(user1), params: inused_params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no email user' do
        before(:each) do
          put user_path(user1), params: no_email_user, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no name user' do
        before(:each) do
          put user_path(user1), params: no_name_user, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it "returns 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
