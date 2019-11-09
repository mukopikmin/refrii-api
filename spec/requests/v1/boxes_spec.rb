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
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      before {  get v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'GET /boxes/owns' do
    context 'without authentication' do
      subject { response.status }

      before { get owns_v1_boxes_path }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      before { get owns_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'GET /boxes/invited' do
    context 'without authentication' do
      subject { response.status }

      before { get invited_v1_boxes_path }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      before { get invited_v1_boxes_path, headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'GET /boxes/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_path(box1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { get v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          get v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'GET /boxes/:id/versions' do
    context 'without authentication' do
      subject { response.status }

      before { get versions_v1_box_path(box1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      before { get versions_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'GET /boxes/:id/units' do
    context 'without authentication' do
      subject { response.status }

      before { get units_v1_box_path(box1) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { get units_v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          get units_v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
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
      it { assert_schema_conform }
    end

    context 'with authentication' do
      subject { response.status }

      before { post v1_boxes_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(201) }
      it { assert_schema_conform }
    end

    context 'with no name params' do
      subject { response.status }

      before do
        post v1_boxes_path, params: no_name_box, headers: { authorization: "Bearer #{token(user1)}" }
      end

      it { is_expected.to eq(400) }
      it { assert_schema_conform }
    end
  end

  describe 'PUT /boxes/:id' do
    let(:params) { attributes_for(:box) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_box_path(box1), params: params }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { put v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_schema_conform }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          put v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
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
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { delete v1_box_path(box1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(204) }
        it { assert_schema_conform }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          delete v1_box_path(box2), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end

      context 'with invited box' do
        subject { response.status }

        before do
          delete v1_box_path(box3), headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end
    end
  end
end
