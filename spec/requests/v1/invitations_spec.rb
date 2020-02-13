# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invitations', type: :request do
  include Committee::Rails::Test::Methods

  let(:box1) { create(:box, :with_owner) }
  let(:box2) { create(:box, :with_owner) }
  let(:box3) { create(:box, owner: box2.owner) }
  let(:invitation) { Invitation.create(box: box3, user: box1.owner) }

  describe 'DELETE /invitations/:id' do
    context 'without authentication' do
      subject { response.status }

      let(:params) { { user_id: box2.owner.to_param } }

      before { delete v1_invitation_path(invitation), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        let(:params) { { email: box1.owner.email } }
        let(:headers) { { authorization: "Bearer #{token(box2.owner)}" } }

        before { delete v1_invitation_path(invitation), params: params, headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        let(:params) { { email: box1.owner.email } }
        let(:headers) { { authorization: "Bearer #{token(box1.owner)}" } }

        before do
          delete v1_invitation_path(invitation), params: params, headers: headers
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with unpersisted user' do
        subject { response.status }

        let(:params) { { email: box1.owner.email } }
        let(:headers) { { authorization: "Bearer #{token(box1.owner)}" } }
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
