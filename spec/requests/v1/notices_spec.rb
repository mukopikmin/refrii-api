# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notices', type: :request do
  include Committee::Rails::Test::Methods

  let(:notice) { create(:notice, :with_food) }
  let(:user) { notice.created_user }
  let(:box) { notice.food.box }
  let(:invisible_user) { create(:user) }
  let(:invited_user) { create(:user) }

  before { Invitation.create(box: box, user: invited_user) }

  describe 'DELETE /notices/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_notice_path(notice) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with notice in own food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(user)}" } }

        before { delete v1_notice_path(notice), headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with notice in other\'s food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(invisible_user)}" } }

        before { delete v1_notice_path(notice), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end

      context 'with notice in invited food' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(invited_user)}" } }

        before { delete v1_notice_path(notice), headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
