# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Units', type: :request do
  include Committee::Rails::Test::Methods

  let(:unit1) { create(:unit, :with_user) }
  let(:unit2) { create(:unit, :with_user) }
  let(:user1) { unit1.user }

  describe 'GET /units' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_units_path }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      subject { response.status }

      before { get v1_units_path, headers: { authorization: "Bearer #{token(user1)}" } }

      it { is_expected.to eq(200) }
      it { assert_response_schema_confirm }
    end
  end

  describe 'GET /units/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_unit_path(unit1) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own unit' do
        subject { response.status }

        before { get v1_unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s unit' do
        subject { response.status }

        before { get v1_unit_path(unit2), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'POST /units' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:unit).merge!(unit_id: unit1.to_param) }

      before { post v1_units_path, params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with valid params' do
        subject { response.status }

        let(:params) { attributes_for(:unit) }

        before { post v1_units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end

      context 'with no label unit' do
        subject { response.status }

        let(:params) { attributes_for(:no_label_unit) }

        before { post v1_units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with existing label unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }

        before do
          Unit.create(params)
          post v1_units_path, params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'PUT /units/:id' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:unit) }

      before { put v1_unit_path(unit1), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit) }

        before { put v1_unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit) }

        before { put v1_unit_path(unit2), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with no label unit' do
        subject { response.status }

        let(:params) { attributes_for(:no_label_unit) }

        before { put v1_unit_path(unit2), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with existing label unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }

        before do
          Unit.create(params)
          put v1_unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'without renaming label of unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit).merge!(user_id: user1.id) }

        before { put v1_unit_path(unit1), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'DELETE /units/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_unit_path(unit1) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own unit' do
        context 'with unit not referenced by foods' do
          subject { response.status }

          before { delete v1_unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" } }

          it { is_expected.to eq(204) }
          it { assert_response_schema_confirm }
        end

        context 'with unit referenced by foods' do
          subject { response.status }

          let(:box) { create(:box, owner: user1) }

          before do
            create(:food, box: box,
                          unit: unit1,
                          created_user: user1,
                          updated_user: user1)
            delete v1_unit_path(unit1), headers: { authorization: "Bearer #{token(user1)}" }
          end

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end
      end

      context 'with other\'s unit' do
        subject { response.status }

        before { delete v1_unit_path(unit2), headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
