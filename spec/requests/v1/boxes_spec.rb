# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes', type: :request do
  include Committee::Test::Methods
  include Rack::Test::Methods

    def token(user)
    JsonWebToken.payload(user)[:jwt]
  end


  def committee_schema
    @committee_schema ||=
      begin
        driver = Committee::Drivers::OpenAPI2.new
        schema = JSON.parse(File.read(schema_path))
        driver.parse(schema)
      end
  end

  def schema_path
    Rails.root.join('docs/swagger.json')
  end

  def committee_options
    @committee_options ||= { validate_errors: true}
  end

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:box1) { create(:box, owner: user1) }
  let(:box2) { create(:box, owner: user2) }
  let(:box3) { create(:box, owner: user2) }

  before { Invitation.create(box: box3, user: user1) }

  describe 'GET /boxes' do
    context 'without authentication' do
      # before { get v1_boxes_path }

      it 'returns 401' do
        header "authorization", "aaaa"
        get v1_boxes_path
        p last_response.body
        p last_response.status
        # expect(response).to have_http_status(:unauthorized)
        assert_schema_conform
      end
    end

    context 'with authentication' do
      # before do
      #   get v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      # end

      it 'returns 200' do
        header "authorization", "Bearer #{token(user1)}" 
        get v1_boxes_path#, headers: { authorization: "Bearer #{token(user1)}" }

        p last_response

        # expect(response).to have_http_status(:ok)
        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/owns' do
    context 'without authentication' do
      # before { get owns_v1_boxes_path }

      it 'returns 401' do
        get owns_v1_boxes_path
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      # before do
      #   get owns_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      # end

      it 'returns 200' do
        get owns_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
        # expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/invited' do
    context 'without authentication' do
      # before { get invited_v1_boxes_path }

      it 'returns 401' do
        get invited_v1_boxes_path
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      # before do
      #   get invited_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
      # end

      it 'returns 200' do
        get invited_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
        # expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/:id' do
    context 'without authentication' do
      # before { get v1_box_path(box1) }

      it 'returns 401' do
        get v1_box_path(box1)
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        # before do
        #   get v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 200' do
          get v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        # before do
        #   get v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 404' do
          get v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'GET /boxes/:id/versions' do
    context 'without authentication' do
      # before { get versions_v1_box_path(box1) }

      it 'returns 401' do
        get versions_v1_box_path(box1)
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      # before do
      #   get versions_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
      # end

      it 'returns 200' do
        get versions_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
        # expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /boxes/:id/image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, :with_image, owner: user) }
    let(:no_image_box) { create(:box, owner: user) }

    context 'without authentication' do
      # before { get image_v1_box_path(box) }

      it 'returns 401' do
        get image_v1_box_path(box)
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with image' do
        # before { get image_v1_box_path(box), headers: { authorization: "Bearer #{token(user)}" } }

        it 'return 200' do
          get image_v1_box_path(box), headers: { authorization: "Bearer #{token(user)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:ok)
        end
      end

      context 'with no image' do
        # before { get image_v1_box_path(no_image_box), headers: { authorization: "Bearer #{token(user)}" } }

        it 'return 404' do
          get image_v1_box_path(no_image_box), headers: { authorization: "Bearer #{token(user)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:not_found)
        end
      end

      context 'with base64 requested param' do
        # before { get image_v1_box_path(box), headers: { authorization: "Bearer #{token(user)}" }, params: { base64: true } }

        it 'return 200' do
          get image_v1_box_path(box), headers: { authorization: "Bearer #{token(user)}" }, params: { base64: true }
          assert_schema_conform
          # expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET /boxes/:id/units' do
    context 'without authentication' do
      # before { get units_v1_box_path(box1) }

      it 'returns 401' do
        get units_v1_box_path(box1)
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        # before do
        #   get units_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 200' do
          get units_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        # before do
        #   get units_v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 404' do
          get units_v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST /boxes' do
    let(:params) { attributes_for(:box) }
    let(:no_name_box) { attributes_for(:no_name_box) }

    context 'without authentication' do
      # before { post v1_boxes_path, params: params }

      it 'returns 401' do
        post v1_boxes_path, params: params
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      # before do
      #   post v1_boxes_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
      # end

      it 'returns 201' do
        post v1_boxes_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
        # expect(response).to have_http_status(:created)
      end
    end

    context 'with no name params' do
      # before do
      #   post v1_boxes_path, params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
      # end

      it 'returns 400' do
        post v1_boxes_path, params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
        # expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT /boxes/:id' do
    let(:params) { attributes_for(:box) }
    let(:no_name_box) { attributes_for(:no_name_box) }

    context 'without authentication' do
      # before { put v1_box_path(box1), params: params }

      it 'returns 401' do
        put v1_box_path(box1), params: params
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        # before do
        #   put v1_box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 200' do
          put v1_box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:ok)
        end
      end

      context 'with other\'s box' do
        # before do
        #   put v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 400' do
          put v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with no name params' do
        # before do
        #   put v1_box_path(box1), params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 400' do
          put v1_box_path(box1), params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'DELETE /boxes/:id' do
    context 'without authentication' do
      # before { delete v1_box_path(box1) }

      it 'returns 401' do
        delete v1_box_path(box1)
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        # before do
        #   delete v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 204' do
          delete v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:no_content)
        end
      end

      context 'with other\'s box' do
        # before do
        #   delete v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 400' do
          delete v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with invited box' do
        # before do
        #   delete v1_box_path(box3), headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 400' do
          delete v1_box_path(box3), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'POST /boxes/:id/invite' do
    let(:params) { { email: user2.email } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      # before { post invite_v1_box_path(box1), params: params }

      it 'returns 401' do
        post invite_v1_box_path(box1), params: params
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        # before do
        #   post invite_v1_box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 201' do
          post invite_v1_box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:created)
        end
      end

      context 'with other\'s box' do
        # before do
        #   post invite_v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 400' do
          post invite_v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with unpersisted user' do
        # before do
        #   post invite_v1_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 400' do
          post invite_v1_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'DELETE /boxes/:id/invite' do
    let(:params) { { user_id: user2.to_param } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      # before { delete invite_v1_box_path(box3), params: params }

      it 'returns 401' do
        delete invite_v1_box_path(box3), params: params
        assert_schema_conform
        # expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authentication' do
      context 'with own box' do
        # before do
        #   delete invite_v1_box_path(box3), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 204' do
          delete invite_v1_box_path(box3), params: params, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:no_content)
        end
      end

      context 'with other\'s box' do
        # before do
        #   delete invite_v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 400' do
          delete invite_v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with unpersisted user' do
        # before do
        #   delete invite_v1_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
        # end

        it 'returns 400' do
          delete invite_v1_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
          # expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
