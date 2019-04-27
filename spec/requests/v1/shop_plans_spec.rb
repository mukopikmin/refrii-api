# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShopPlans', type: :request do
  include Committee::Rails::Test::Methods

  describe 'GET /shop_plans' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, unit: unit, box: box, created_user: user, updated_user: user) }
    let(:plan) { create(:shop_plan, food: food) }

    context 'without authentication' do
      subject { response.status }

      before { get v1_shop_plans_path }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authnetication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }

      before { get v1_shop_plans_path, headers: headers }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'GET /shop_plans/:id' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, unit: unit, box: box, created_user: user, updated_user: user) }
    let(:plan) { create(:shop_plan, food: food) }

    context 'without authentication' do
      subject { response.status }

      before { get v1_shop_plan_path(plan) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authnetication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }

      before { get v1_shop_plan_path(plan), headers: headers }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'POST /shop_plans' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, unit: unit, box: box, created_user: user, updated_user: user) }
    let(:plan) { create(:shop_plan, food: food) }

    context 'without authentication' do
      subject { response.status }

      before { post v1_shop_plans_path }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authnetication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }
      let(:params) { attributes_for(:shop_plan).merge(food_id: food.to_param) }

      before { post v1_shop_plans_path, headers: headers, params: params }

      it { is_expected.to eq(201) }
      it { assert_schema_conform }
    end
  end

  describe 'PUT /shop_plans/:id' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, unit: unit, box: box, created_user: user, updated_user: user) }
    let(:plan) { create(:shop_plan, food: food) }

    context 'without authentication' do
      subject { response.status }

      before { put v1_shop_plan_path(plan) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authnetication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }
      let(:params) { attributes_for(:shop_plan).merge(food_id: food.to_param) }

      before { put v1_shop_plan_path(plan), headers: headers, params: params }

      it { is_expected.to eq(200) }
      it { assert_schema_conform }
    end
  end

  describe 'DELETE /shop_plans/:id' do
    let(:user) { create(:user) }
    let(:box) { create(:box, owner: user) }
    let(:unit) { create(:unit, user: user) }
    let(:food) { create(:food, unit: unit, box: box, created_user: user, updated_user: user) }
    let(:plan) { create(:shop_plan, food: food) }

    context 'without authentication' do
      subject { response.status }

      before { delete v1_shop_plan_path(plan) }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authnetication' do
      subject { response.status }

      let(:headers) { { authorization: "Bearer #{token(user)}" } }

      before { delete v1_shop_plan_path(plan), headers: headers }

      it { is_expected.to eq(204) }
      it { assert_schema_conform }
    end
  end
end
