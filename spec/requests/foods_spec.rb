require 'rails_helper'

RSpec.describe "Foods", type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:box1) { create(:box, user: user1) }
  let(:box2) { create(:box, user: user2) }
  let(:unit1) { create(:unit, user: user1) }
  let(:unit2) { create(:unit, user: user2) }
  let(:food1) { create(:food, box: box1, unit: unit1) }
  let(:food2) { create(:food, box: box2, unit: unit2) }

  describe 'GET /foods' do
    context 'without authentication' do
      before(:each) { get foods_path }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        token = Knock::AuthToken.new(payload: { sub: user1.id }).token
        get foods_path, headers: { authorization: "Bearer #{token}" }
      end

      it "returns 200" do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /food/:id' do
    context 'without authentication' do
      before(:each) { get food_path(food1) }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          token = Knock::AuthToken.new(payload: { sub: user1.id }).token
          get food_path(food1), headers: { authorization: "Bearer #{token}" }
        end

        it "returns 200" do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          token = Knock::AuthToken.new(payload: { sub: user1.id }).token
          get food_path(food2), headers: { authorization: "Bearer #{token}" }
        end

        it "returns 403" do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'POST /foods' do
    context 'without authentication' do
      let(:params) { attributes_for(:food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }
      before(:each) { post foods_path, params: params }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        let(:params) { attributes_for(:food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

        before(:each) do
          token = Knock::AuthToken.new(payload: { sub: user1.id }).token
          post foods_path, params: params, headers: { authorization: "Bearer #{token}" }
        end

        it "returns 201" do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with other\'s box' do
        let(:params) { attributes_for(:food).merge!(box_id: box2.to_param, unit_id: unit2.to_param) }

        before(:each) do
          token = Knock::AuthToken.new(payload: { sub: user1.id }).token
          post foods_path, params: params, headers: { authorization: "Bearer #{token}" }
        end

        it "returns 403" do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'PUT /foods/:id' do
    let(:params) { attributes_for(:food) }

    context 'without authentication' do
      before(:each) { put food_path(food1), params: params }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          token = Knock::AuthToken.new(payload: { sub: user1.id }).token
          put food_path(food1), params: params, headers: { authorization: "Bearer #{token}" }
        end

        it "returns 201" do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          token = Knock::AuthToken.new(payload: { sub: user1.id }).token
          put food_path(food2), params: params, headers: { authorization: "Bearer #{token}" }
        end

        it "returns 403" do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'DELETE /foods/:id' do
    context 'without authentication' do
      before(:each) { delete food_path(food1) }

      it "returns 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          token = Knock::AuthToken.new(payload: { sub: user1.id }).token
          delete food_path(food1), headers: { authorization: "Bearer #{token}" }
        end

        it "returns 201" do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          token = Knock::AuthToken.new(payload: { sub: user1.id }).token
          delete food_path(food2), headers: { authorization: "Bearer #{token}" }
        end

        it "returns 403" do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
