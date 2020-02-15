# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes', type: :request do
  include Committee::Rails::Test::Methods

  let(:box) { create(:box, :with_owner) }
  let(:invisible_box) { create(:box, :with_owner) }
  let(:invited_box) { create(:box, :with_owner) }
  let(:user) { box.owner }

  before { Invitation.create(box: invited_box, user: user) }

  describe 'GET /boxes' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_boxes_path }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with no option' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:body) { JSON.parse(response.body) }
        let(:result) { body.map { |box| box['is_invited'] } }

        before { get v1_boxes_path, headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }

        it 'returns all boxes' do
          expect(result).to include(be_truthy)
          expect(result).to include(be_falsey)
        end
      end

      context 'with owns filter option' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:body) { JSON.parse(response.body) }
        let(:result) { body.map { |box| box['is_invited'] } }
        let(:params) { { filter: 'owns' } }

        before { get v1_boxes_path, headers: headers, params: params }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }

        it 'returns only own boxes' do
          expect(result).to all(be_falsey)
        end
      end

      context 'with invited filter option' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:body) { JSON.parse(response.body) }
        let(:result) { body.map { |box| box['is_invited'] } }
        let(:params) { { filter: 'invited' } }

        before { get v1_boxes_path, headers: headers, params: params }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }

        it 'returns only invited boxes' do
          expect(result).to all(be_truthy)
        end
      end

      context 'with unknown option' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { { filter: 'unknown' } }

        before { get v1_boxes_path, headers: headers, params: params }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'GET /boxes/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_path(box) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_box_path(box), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_box_path(invited_box), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_box_path(invisible_box), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'POST /boxes' do
    let(:params) { attributes_for(:box) }

    context 'without authentication' do
      subject { response.status }

      before { post v1_boxes_path, params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with valid params' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { post v1_boxes_path, params: params, headers: headers }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end

      context 'with no name params' do
        subject { response.status }

        let(:no_name_box) { attributes_for(:no_name_box) }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { post v1_boxes_path, params: no_name_box, headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'PUT /boxes/:id' do
    let(:params) { attributes_for(:box) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_box_path(box), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        context 'with fullfilled params' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { put v1_box_path(box), headers: headers }

          it { is_expected.to eq(200) }
          it { assert_response_schema_confirm }
        end

        context 'with no name params' do
          subject { response.status }

          let(:no_name_params) { attributes_for(:no_name_box) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { put v1_box_path(box), params: no_name_params, headers: headers }

          it { is_expected.to eq(200) }
          it { assert_response_schema_confirm }
        end
      end

      context 'with other\'s box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { put v1_box_path(invisible_box), params: params, headers: headers }

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end

      context 'with invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { put v1_box_path(invited_box), params: params, headers: headers }

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'DELETE /boxes/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_box_path(box) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_box_path(box), headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_box_path(invisible_box), headers: headers }

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end

      context 'with invited box' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_box_path(invited_box), headers: headers}

        it { is_expected.to eq(403) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
