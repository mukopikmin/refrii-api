# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Units', type: :request do
  include Committee::Rails::Test::Methods

  let(:unit) { create(:unit, :with_user) }
  let(:invited_box) { create(:box, :with_owner) }
  let(:invited_unit) { create(:unit, user: invited_box.owner) }
  let(:invisible_unit) { create(:unit, :with_user) }
  let(:user) { unit.user }

  before { Invitation.create(box: invited_box, user: user) }

  describe 'GET /units' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_units_path }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }

      before { get v1_units_path, headers: headers }

      it { is_expected.to eq(200) }
      it { assert_response_schema_confirm }
    end
  end

  describe 'GET /units/:id' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_unit_path(unit) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own unit' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_unit_path(unit), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with invited unit' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_unit_path(invited_unit), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s unit' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { get v1_unit_path(invisible_unit), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'POST /units' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:unit).merge!(unit_id: unit.to_param) }

      before { post v1_units_path, params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with valid params' do
        subject { response.status }

        let(:params) { attributes_for(:unit) }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { post v1_units_path, params: params, headers: headers }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end

      context 'with invalid params' do
        context 'with no label unit' do
          subject { response.status }

          let(:params) { attributes_for(:no_label_unit) }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { post v1_units_path, params: params, headers: headers }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with empty label unit' do
          subject { response.status }

          let(:params) { attributes_for(:unit, :with_empty_label) }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { post v1_units_path, params: params, headers: headers }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with existing label unit' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }
          let(:params) { unit.attributes.merge!(user_id: user.id) }

          before do
            post v1_units_path, params: params, headers: headers
          end

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with other user' do
          subject { response.status }

          let(:params) { attributes_for(:unit).merge!(user_id: invisible_unit.user) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { post v1_units_path, params: params, headers: headers }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }
        end

        context 'with no step' do
          subject { response.status }

          let(:step) { JSON.parse(response.body)['step'] }

          let(:params) { attributes_for(:no_step_unit) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { post v1_units_path, params: params, headers: headers }

          it { is_expected.to eq(201) }
          it { assert_response_schema_confirm }

          it 'uses default positive value' do
            expect(step).to be > 0
          end
        end

        context 'with negative step' do
          subject { response.status }

          let(:params) { attributes_for(:unit, :with_negative_step) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { post v1_units_path, params: params, headers: headers }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'with zero step' do
          subject { response.status }

          let(:params) { attributes_for(:unit, :with_zero_step) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { post v1_units_path, params: params, headers: headers }

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end
      end
    end
  end

  describe 'PUT /units/:id' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:unit) }

      before { put v1_unit_path(unit), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own unit' do
        context 'with full filled params' do
          subject { response.status }

          let(:params) { attributes_for(:unit) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { put v1_unit_path(unit), params: params, headers: headers }

          it { is_expected.to eq(200) }
          it { assert_response_schema_confirm }
        end

        context 'with no label unit' do
          subject { response.status }

          let(:params) { attributes_for(:no_label_unit) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { put v1_unit_path(unit), params: params, headers: headers }

          it { is_expected.to eq(200) }
          it { assert_response_schema_confirm }
        end

        context 'with existing label unit' do
          subject { response.status }

          let(:params) { attributes_for(:unit).merge!(user_id: user.id) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before do
            Unit.create(params)
            put v1_unit_path(unit), params: params, headers: headers
          end

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end

        context 'without renaming label of unit' do
          subject { response.status }

          let(:params) { attributes_for(:unit).merge!(user_id: user.id) }
          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { put v1_unit_path(unit), params: params, headers: headers }

          it { is_expected.to eq(200) }
          it { assert_response_schema_confirm }
        end
      end

      context 'with other\'s unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit) }
        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { put v1_unit_path(invisible_unit), params: params, headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with invited unit' do
        subject { response.status }

        let(:params) { attributes_for(:unit) }
        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { put v1_unit_path(invited_unit), params: params, headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end

  describe 'DELETE /units/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_unit_path(unit) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own unit' do
        context 'with unit not referenced by foods' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before { delete v1_unit_path(unit), headers: headers }

          it { is_expected.to eq(204) }
          it { assert_response_schema_confirm }
        end

        context 'with unit referenced by foods' do
          subject { response.status }

          let(:headers) { { authorization: "Bearer #{token(user)}" } }

          before do
            create(:food, :with_box_user_unit, unit: unit)
            delete v1_unit_path(unit), headers: headers
          end

          it { is_expected.to eq(400) }
          it { assert_response_schema_confirm }
        end
      end

      context 'with other\'s unit' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_unit_path(invisible_unit), headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with invited unit' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_unit_path(invited_unit), headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
