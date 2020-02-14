# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes/Invitations', type: :request do
  include Committee::Rails::Test::Methods

  let(:box) { create(:box, :with_owner) }
let(:user) {box.owner}
let(:invited_box) { create(:box, :with_owner) }
  let(:invisible_box) { create(:box, :with_owner) }
  before { Invitation.create(box: invisible_box, user: user) }

  describe 'POST /boxes/:id/invitations' do
    let(:params) { { email: invited_user.email } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      subject { response.status }

      before { post v1_box_invitations_path(box_id: box.id), params: params }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { post v1_box_invitations_path(box_id: box.id), params: params, headers: { authorization: "Bearer #{token(user)}" } }

        it { is_expected.to eq(201) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          post v1_box_invitations_path(box_id: invited_box.id), params: params, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end

      context 'with unpersisted user' do
        subject { response.status }

        before do
          post v1_box_invitations_path(box), params: unpersisted_user, headers: { authorization: "Bearer #{token(user)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
