# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notices', type: :request do
  include Committee::Rails::Test::Methods

  describe 'POST /foods/:food_id/notices' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, unit: unit, box: box, created_user: user, updated_user: user) }

    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:notice) }

      before { post v1_food_notices_path(food) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with  own food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { post v1_food_notices_path(food), headers: headers, params: params }

        it { is_expected.to eq(201) }
        it { assert_schema_conform }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:other_user) { create(:user) }
        let(:headers) { { authorization: "Bearer #{token(other_user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { post v1_food_notices_path(food), headers: headers, params: params }

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:other_user) { create(:user) }
        let(:headers) { { authorization: "Bearer #{token(other_user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { Invitation.create(box: box, user: other_user) }

        before { post v1_food_notices_path(food), headers: headers, params: params }

        it { is_expected.to eq(201) }
        it { assert_schema_conform }
      end
    end
  end

  describe 'DELETE /foods/:food_id/notices/:id' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:notice) { create(:notice, food: food, created_user: user, updated_user: user) }
    let(:food) do
      create(:food, unit: unit,
                    box: box,
                    created_user: user,
                    updated_user: user)
    end

    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:notice) }

      before { delete v1_food_notice_path(food_id: food, id: notice) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context   'with  own food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { delete v1_food_notice_path(food_id: food, id: notice), headers: headers, params: params }

        it { is_expected.to eq(204) }
        it { assert_schema_conform }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:other_user) { create(:user) }
        let(:headers) { { authorization: "Bearer #{token(other_user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { delete v1_food_notice_path(food_id: food, id: notice), headers: headers, params: params }

        it { is_expected.to eq(404) }
        it { assert_schema_conform }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:other_user) { create(:user) }
        let(:headers) { { authorization: "Bearer #{token(other_user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { Invitation.create(box: box, user: other_user) }

        before { delete v1_food_notice_path(food_id: food, id: notice), headers: headers, params: params }

        it { is_expected.to eq(204) }
        it { assert_schema_conform }
      end
    end
  end
end
