# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:box1) { create(:box, owner: user1) }
  let(:box2) { create(:box, owner: user2) }
  let(:unit1) { create(:unit, user: user1) }
  let(:unit2) { create(:unit, user: user2) }
  let(:food1) do
    create(:food, box: box1,
                  unit: unit1,
                  created_user: box1.owner,
                  updated_user: box1.owner)
  end
  let(:food2) do
    create(:food, box: box2,
                  unit: unit2,
                  created_user: box2.owner,
                  updated_user: box2.owner)
  end

  describe 'GET /foods' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_foods_path }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      it 'conforms schema' do
        get v1_foods_path, headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
      end
    end
  end

  describe 'GET /foods/:id' do
    context 'without authentication' do
      before { get v1_food_path(food1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with food in own box' do
        before do
          get v1_food_path(food1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with food in other\'s box' do
        before do
          get v1_food_path(food2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 404' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'GET /foods/:id/versions' do
    context 'without authentication' do
      before { get versions_v1_food_path(food1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before do
        get versions_v1_food_path(food1), headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /foods/:id/image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, :with_image, box: box, unit: unit, created_user: user, updated_user: user) }
    let(:no_image_food) { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

    context 'without authentication' do
      before { get image_v1_food_path(food) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with image' do
        before { get image_v1_food_path(food), headers: { authorization: "Bearer #{token(user)}" } }

        it 'return 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with no image' do
        before { get image_v1_food_path(no_image_food), headers: { authorization: "Bearer #{token(user)}" } }

        it 'return 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with base64 requested param' do
        before { get image_v1_food_path(food), headers: { authorization: "Bearer #{token(user)}" }, params: { base64: true } }

        it 'return 200' do
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'POST /foods' do
    context 'without authentication' do
      let(:params) { attributes_for(:food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

      before { post v1_foods_path, params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with food in own box' do
        let(:params) { attributes_for(:food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

        before do
          post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with food in other\'s box' do
        let(:params) { attributes_for(:food).merge!(box_id: box2.to_param, unit_id: unit2.to_param) }

        before do
          post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no name food' do
        let(:params) { attributes_for(:no_name_food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

        before do
          post v1_foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'PUT /foods/:id' do
    let(:params) { attributes_for(:food) }
    let(:no_name_params) { attributes_for(:no_name_food) }

    context 'without authentication' do
      before { put v1_food_path(food1), params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with food in own box' do
        before do
          put v1_food_path(food1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 201' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with food in other\'s box' do
        before do
          put v1_food_path(food2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no name food' do
        before do
          put v1_food_path(food1), params: no_name_params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'DELETE /foods/:id' do
    context 'without authentication' do
      before { delete v1_food_path(food1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with food in own box' do
        before do
          delete v1_food_path(food1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 201' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with food in other\'s box' do
        before do
          delete v1_food_path(food2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
