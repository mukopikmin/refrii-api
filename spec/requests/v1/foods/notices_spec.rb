# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Foods/Notices', type: :request do
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
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with  own food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { post v1_food_notices_path(food), headers: headers, params: params }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:other_user) { create(:user) }
        let(:headers) { { authorization: "Bearer #{token(other_user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { post v1_food_notices_path(food), headers: headers, params: params }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:other_user) { create(:user) }
        let(:headers) { { authorization: "Bearer #{token(other_user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: food.to_param) }

        before { Invitation.create(box: box, user: other_user) }

        before { post v1_food_notices_path(food), headers: headers, params: params }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
