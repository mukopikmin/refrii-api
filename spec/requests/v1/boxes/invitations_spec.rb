# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes/Invitations', type: :request do
  include Committee::Rails::Test::Methods

  let!(:box1) { create(:box, :with_owner) }
  let!(:box2) { create(:box, :with_owner) }
  let!(:box3) { create(:box, :with_owner) }

  before { Invitation.create(box: box3, user: box1.owner) }

  describe 'POST /boxes/:id/invitations' do
    let(:params) { { email: box2.owner.email } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      subject { response.status }

      before { post v1_box_invitations_path(box_id: box1.id), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { post v1_box_invitations_path(box_id: box1.id), params: params, headers: { authorization: "Bearer #{token(box1.owner)}" } }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          post v1_box_invitations_path(box_id: box2.id), params: params, headers: { authorization: "Bearer #{token(box1.owner)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with unpersisted user' do
        subject { response.status }

        before do
          post v1_box_invitations_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(box1.owner)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
