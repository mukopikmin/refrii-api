require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  def token(user)
    JsonWebToken.payload(user)[:jwt]
  end

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:box1) { create(:box, user: user1) }
  let(:box2) { create(:box, user: user2) }
  let(:unit1) { create(:unit, user: user1) }
  let(:unit2) { create(:unit, user: user2) }
  let(:food1) do
    create(:food, box: box1,
                  unit: unit1,
                  created_user: box1.user,
                  updated_user: box1.user)
  end
  let(:food2) do
    create(:food, box: box2,
                  unit: unit2,
                  created_user: box2.user,
                  updated_user: box2.user)
  end

  describe 'GET /foods' do
    context 'without authentication' do
      before(:each) { get foods_path }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        get foods_path, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /foods/:id' do
    context 'without authentication' do
      before(:each) { get food_path(food1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with food in own box' do
        before(:each) do
          get food_path(food1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with food in other\'s box' do
        before(:each) do
          get food_path(food2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 404' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST /foods' do
    context 'without authentication' do
      let(:params) { attributes_for(:food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }
      before(:each) { post foods_path, params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with food in own box' do
        let(:params) { attributes_for(:food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

        before(:each) do
          post foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with food in other\'s box' do
        let(:params) { attributes_for(:food).merge!(box_id: box2.to_param, unit_id: unit2.to_param) }

        before(:each) do
          post foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no name food' do
        let(:params) { attributes_for(:no_name_food).merge!(box_id: box1.to_param, unit_id: unit1.to_param) }

        before(:each) do
          post foods_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
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
      before(:each) { put food_path(food1), params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with food in own box' do
        before(:each) do
          put food_path(food1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 201' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with food in other\'s box' do
        before(:each) do
          put food_path(food2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no name food' do
        before(:each) do
          put food_path(food1), params: no_name_params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'DELETE /foods/:id' do
    context 'without authentication' do
      before(:each) { delete food_path(food1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with food in own box' do
        before(:each) do
          delete food_path(food1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 201' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with food in other\'s box' do
        before(:each) do
          delete food_path(food2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
