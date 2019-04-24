# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }
  let!(:box3) { create(:box, owner: user2) }

  before { Invitation.create(box: box3, user: user1) }

  describe 'GET /boxes' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_boxes_path }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      it 'conforms schema' do
        get v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/owns' do
    context 'without authentication' do
      subject { response.status }

      before { get owns_v1_boxes_path }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      it 'conforms schema' do
        get owns_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/invited' do
    context 'without authentication' do
      subject { response.status }

      before { get invited_v1_boxes_path }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      it 'returns 200' do
        get invited_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_path(box1) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 200' do
          get v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          get v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(404) }
      end
    end
  end

  describe 'GET /boxes/:id/versions' do
    context 'without authentication' do
      subject { response.status }

      before { get versions_v1_box_path(box1) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      it 'returns 200' do
        get versions_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
      end
    end
  end

  describe 'GET /boxes/:id/image' do
    let(:user) { create(:user) }
    let(:box) { create(:box, :with_image, owner: user) }
    let(:no_image_box) { create(:box, owner: user) }

    context 'without authentication' do
      subject { response.status }

      before { get image_v1_box_path(box) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with image' do
        subject { response.status }

        before do
          get image_v1_box_path(box), headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(200) }
      end

      context 'with no image' do
        subject { response.status }

        before do
          get image_v1_box_path(no_image_box), headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(404) }
      end

      context 'with base64 requested param' do
        subject { response.status }

        before do
          get image_v1_box_path(box), params: { base64: true }, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(200) }
      end
    end
  end

  describe 'GET /boxes/:id/units' do
    context 'without authentication' do
      subject { response.status }

      before { get units_v1_box_path(box1) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 200' do
          get units_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          get units_v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(404) }
      end
    end
  end

  describe 'POST /boxes' do
    let(:params) { attributes_for(:box) }
    let(:no_name_box) { attributes_for(:no_name_box) }

    context 'without authentication' do
      subject { response.status }

      before { post v1_boxes_path, params: params }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      it 'returns 201' do
        post v1_boxes_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        assert_schema_conform
      end
    end

    context 'with no name params' do
      subject { response.status }

      before do
        post v1_boxes_path, params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it { is_expected.to eq(400) }
    end
  end

  describe 'PUT /boxes/:id' do
    let(:params) { attributes_for(:box) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_box_path(box1), params: params }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 200' do
          put v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          put v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end

      context 'with no name params' do
        subject { response.status }

        let(:no_name_box) { attributes_for(:no_name_box) }

        before { put v1_box_path(box1), params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'DELETE /boxes/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_box_path(box1) }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 204' do
          delete v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          delete v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end

      context 'with invited box' do
        subject { response.status }

        before do
          delete v1_box_path(box3), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end
    end
  end

  describe 'POST /boxes/:id/invite' do
    let(:params) { { email: user2.email } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      subject { response.status }

      before { post invite_v1_box_path(box1), params: params }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own box' do
        it 'returns 201' do
          post invite_v1_box_path(box1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
          assert_schema_conform
        end
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          post invite_v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end

      context 'with unpersisted user' do
        subject { response.status }

        before do
          post invite_v1_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end
    end
  end

  describe 'DELETE /boxes/:id/invite' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { { user_id: user2.to_param } }

      before { delete invite_v1_box_path(box3), params: params }

      it { is_expected.to eq(401) }
    end

    context 'with authentication' do
      context 'with own box' do
        let(:params) { { email: user1.email } }

        before { delete invite_v1_box_path(box3), params: params, headers: { authorization: "Bearer #{token(user2)}" } }

        it { assert_schema_conform }
      end

      context 'with other\'s box' do
        subject { response.status }

        let(:params) { { email: user1.email } }

        before do
          delete invite_v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end

      context 'with unpersisted user' do
        subject { response.status }

        let(:params) { { email: user1.email } }
        let(:unpersisted_user) { attributes_for(:user) }

        before do
          delete invite_v1_box_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
      end
    end
  end
end
