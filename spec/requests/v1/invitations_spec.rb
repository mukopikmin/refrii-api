# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Invitations', type: :request do
  include Committee::Rails::Test::Methods

  let(:box) { create(:box, :with_owner) }
  let(:invited_user) { create(:user) }
  let(:not_invited_user) { create(:user) }
  let(:invitation) { Invitation.create(box: box, user: invited_user) }

  describe 'DELETE /invitations/:id' do
    context 'without authentication' do
      subject { response.status }

      before { delete v1_invitation_path(invitation) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with box owner' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(box.owner)}" } }

        before { delete v1_invitation_path(invitation), headers: headers }

        it { is_expected.to eq(204) }
        it { assert_response_schema_confirm }
      end

      context 'with invited user' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(invited_user)}" } }

        before { delete v1_invitation_path(invitation), headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with not invited user' do
        subject { response.status }

        let(:headers) { { authorization: "Bearer #{token(not_invited_user)}" } }

        before { delete v1_invitation_path(invitation), headers: headers }

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
