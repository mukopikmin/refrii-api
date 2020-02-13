# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes', type: :request do
  include Committee::Rails::Test::Methods

  let!(:box1) { create(:box, :with_owner) }
  let!(:box2) { create(:box, :with_owner) }
  let!(:box3) { create(:box, :with_owner) }

  before { Invitation.create(box: box3, user: box1.owner) }

  describe 'GET /boxes' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_boxes_path }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      subject { response.status }

      before {  get v1_boxes_path, headers: { authorization: "Bearer #{token(box1.owner)}" } }

      it { is_expected.to eq(200) }
      it { assert_response_schema_confirm }

      context 'with owns filter option' do
        subject { response.status }

        let(:body) { JSON.parse(response.body) }
        let(:result) { body.map { |box| box['is_invited'] } }
        let(:params) { { filter: 'owns' } }

        before { get v1_boxes_path, headers: { authorization: "Bearer #{token(box1.owner)}" }, params: params }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }

        it 'returns only own boxes' do
          expect(result).to all(be_falsey)
        end
      end

      context 'with invited filter option' do
        subject { response.status }

        let(:body) { JSON.parse(response.body) }
        let(:result) { body.map { |box| box['is_invited'] } }
        let(:params) { { filter: 'invited' } }

        before { get v1_boxes_path, headers: { authorization: "Bearer #{token(box1.owner)}" }, params: params }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }

        it 'returns only invited boxes' do
          expect(result).to all(be_truthy)
        end
      end
    end
  end

  describe 'GET /boxes/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_path(box1) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { get v1_box_path(box1), headers: { authorization: "Bearer #{token(box1.owner)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          get v1_box_path(box2), headers: { authorization: "Bearer #{token(box1.owner)}" }
        end

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
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
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      subject { response.status }

      before { post v1_boxes_path, params: params, headers: { authorization: "Bearer #{token(box1.owner)}" } }

      it { is_expected.to eq(201) }
      it { assert_response_schema_confirm }
    end

    context 'with no name params' do
      subject { response.status }

      before do
        post v1_boxes_path, params: no_name_box, headers: { authorization: "Bearer #{token(box1.owner)}" }
      end

      it { is_expected.to eq(400) }
      it { assert_response_schema_confirm }
    end
  end

  describe 'PUT /boxes/:id' do
    let(:params) { attributes_for(:box) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_box_path(box1), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { put v1_box_path(box1), headers: { authorization: "Bearer #{token(box1.owner)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          put v1_box_path(box2), params: params, headers: { authorization: "Bearer #{token(box1.owner)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with no name params' do
        subject { response.status }

        let(:no_name_box) { attributes_for(:no_name_box) }

        before { put v1_box_path(box1), params: no_name_box, headers: { authorization: "Bearer #{token(box1.owner)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'DELETE /boxes/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_box_path(box1) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { delete v1_box_path(box1), headers: { authorization: "Bearer #{token(box1.owner)}" } }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          delete v1_box_path(box2), headers: { authorization: "Bearer #{token(box1.owner)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with invited box' do
        subject { response.status }

        before do
          delete v1_box_path(box3), headers: { authorization: "Bearer #{token(box1.owner)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
