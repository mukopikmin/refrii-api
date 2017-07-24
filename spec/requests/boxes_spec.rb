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
  let(:unit1) { create(:unit, box: box1, user: user1) }
  let(:unit1) { create(:unit, box: box2, user: user2) }
  let!(:invitation) { Invitation.create(box: box3, user: user1) }

  describe 'GET /boxes' do
    context 'without authentication' do
      before(:each) { get boxes_path }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        get boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/owns' do
    context 'without authentication' do
      before(:each) { get owns_boxes_path }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        get owns_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/invited' do
    context 'without authentication' do
      before(:each) { get invited_boxes_path }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        get invited_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/:id' do
    context 'without authentication' do
      before(:each) { get box_path(box1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          get box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          get box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
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
      before(:each) { get image_box_path(box) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'if image exists' do
        before(:each) { get image_box_path(box), headers: { authorization: "Bearer #{token(user)}" } }

        it 'return 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'if no image exists' do
        before(:each) { get image_box_path(no_image_box), headers: { authorization: "Bearer #{token(user)}" } }

        it 'return 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with base64 requested param' do
        before(:each) { get image_box_path(box), headers: { authorization: "Bearer #{token(user)}" }, params: { base64: true } }

        it 'return 200' do
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET /boxes/:id/units' do
    context 'without authentication' do
      before(:each) { get units_box_path(box1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          get units_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          get units_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
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
      before(:each) { post boxes_path, params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      before(:each) do
        post boxes_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it 'returns 201' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with no name params' do
      before(:each) do
        post boxes_path, params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
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
      before(:each) { put box_path(box1), params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          put box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 200' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          put box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no name params' do
        before(:each) do
          put box_path(box1), params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'DELETE /boxes/:id' do
    context 'without authentication' do
      before(:each) { delete box_path(box1) }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          delete box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 204' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          delete box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invited box' do
        before(:each) do
          delete box_path(box3), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'POST /boxes/:id/invite' do
    let(:params) { { user_id: user2.to_param } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      before(:each) { post invite_box_path(box1), params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          post invite_box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          post invite_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with unpersisted user' do
        before(:each) do
          post invite_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
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
      before(:each) { delete invite_box_path(box3), params: params }

      it 'returns 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        before(:each) do
          delete invite_box_path(box3), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 204' do
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with other\'s box' do
        before(:each) do
          delete invite_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with unpersisted user' do
        before(:each) do
          delete invite_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it 'returns 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
