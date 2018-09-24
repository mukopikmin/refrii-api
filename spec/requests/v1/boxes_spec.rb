# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes', type: :request do
  def token(user)
    JsonWebToken.payload(user)[:jwt]
  end

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:box1) { create(:box, owner: user1) }
  let(:box2) { create(:box, owner: user2) }
  let(:box3) { create(:box, owner: user2) }

  before { Invitation.create(box: box3, user: user1) }

  describe 'GET /boxes' do
    context 'without authentication' do
      before { get v1_boxes_path }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before do
        get v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/owns' do
    context 'without authentication' do
      before { get owns_v1_boxes_path }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before do
        get owns_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/invited' do
    context 'without authentication' do
      before { get invited_v1_boxes_path }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before do
        get invited_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/:id' do
    context 'without authentication' do
      before { get v1_box_path(box1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before do
          get v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        before do
          get v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 404' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'GET /boxes/:id/image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, :with_image, owner: user) }
    let(:no_image_box) { create(:box, owner: user) }

    context 'without authentication' do
      before { get image_v1_box_path(box) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with image' do
        before { get image_v1_box_path(box), headers: { authorization: "Bearer #{token(user)}" } }

        it 'return 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with no image' do
        before { get image_v1_box_path(no_image_box), headers: { authorization: "Bearer #{token(user)}" } }

        it 'return 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with base64 requested param' do
        before { get image_v1_box_path(box), headers: { authorization: "Bearer #{token(user)}" }, params: { base64: true } }

        it 'return 200' do
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET /boxes/:id/units' do
    context 'without authentication' do
      before { get units_v1_box_path(box1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before do
          get units_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        before do
          get units_v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 404' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST /boxes' do
    let(:params) { attributes_for(:box) }
    let(:no_name_box) { attributes_for(:no_name_box) }

    context 'without authentication' do
      before { post v1_boxes_path, params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before do
        post v1_boxes_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with no name params' do
      before do
        post v1_boxes_path, params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 400' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT /boxes/:id' do
    let(:params) { attributes_for(:box) }
    let(:no_name_box) { attributes_for(:no_name_box) }

    context 'without authentication' do
      before { put v1_box_path(box1), params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before do
          put v1_box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        before do
          put v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no name params' do
        before do
          put v1_box_path(box1), params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'DELETE /boxes/:id' do
    context 'without authentication' do
      before { delete v1_box_path(box1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before do
          delete v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 204' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with other\'s box' do
        before do
          delete v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invited box' do
        before do
          delete v1_box_path(box3), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'POST /boxes/:id/invite' do
    let(:params) { { email: user2.email } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      before { post invite_v1_box_path(box1), params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before do
          post invite_v1_box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with other\'s box' do
        before do
          post invite_v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with unpersisted user' do
        before do
          post invite_v1_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'DELETE /boxes/:id/invite' do
    let(:params) { { user_id: user2.to_param } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      before { delete invite_v1_box_path(box3), params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before do
          delete invite_v1_box_path(box3), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 204' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with other\'s box' do
        before do
          delete invite_v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with unpersisted user' do
        before do
          delete invite_v1_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
