# frozen_string_literal: true

# TODO: Refactoring

require 'rails_helper'

RSpec.describe 'Notices', type: :request do
  include Committee::Rails::Test::Methods

  describe 'DELETE /notices/:id' do
    let(:notice) { create(:notice, :with_food) }
    let(:user) { notice.created_user }
    let(:box) { notice.food.box }

    context 'without authentication' do
      subject { response.status }

      let(:params) { attributes_for(:notice) }

      before { delete v1_notice_path(id: notice) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context   'with  own food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: notice.food.to_param) }

        before { delete v1_notice_path(id: notice), headers: headers, params: params }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s food' do
        subject { response.status }

        let(:other_user) { create(:user) }
        let(:headers) { { authorization: "Bearer #{token(other_user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: notice.food.to_param) }

        before { delete v1_notice_path(id: notice), headers: headers, params: params }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end

      context 'with food in invited box' do
        subject { response.status }

        let(:other_user) { create(:user) }
        let(:headers) { { authorization: "Bearer #{token(other_user)}" } }
        let(:params) { attributes_for(:notice).merge(food_id: notice.food.to_param) }

        before { Invitation.create(box: box, user: other_user) }

        before { delete v1_notice_path(id: notice), headers: headers, params: params }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
