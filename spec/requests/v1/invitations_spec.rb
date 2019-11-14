# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invitations', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }
  let(:box3) { create(:box, owner: user2) }
  let(:invitation) { Invitation.create(box: box3, user: user1) }

  describe 'DELETE /invitations/:id' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { { user_id: user2.to_param } }

      before { delete v1_invitation_path(invitation), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        let(:params) { { email: user1.email } }
        let(:headers) { { authorization: "Bearer #{token(user2)}" } }

        before { delete v1_invitation_path(invitation), params: params, headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        let(:params) { { email: user1.email } }
        let(:headers) { { authorization: "Bearer #{token(user1)}" } }

        before do
          delete v1_invitation_path(invitation), params: params, headers: headers
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with unpersisted user' do
        subject { response.status }

        let(:params) { { email: user1.email } }
        let(:headers) { { authorization: "Bearer #{token(user1)}" } }
        let(:unpersisted_user) { attributes_for(:user) }

        before do
          delete v1_invitation_path(invitation), params: unpersisted_user, headers: headers
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
