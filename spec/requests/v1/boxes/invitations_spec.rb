# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes/Invitations', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }
  let!(:box3) { create(:box, owner: user2) }

  before { Invitation.create(box: box3, user: user1) }

  describe 'POST /boxes/:id/invitations' do
    let(:params) { { email: user2.email } }
    let(:unpersisted_user) { attributes_for(:user) }

    context 'without authentication' do
      subject { response.status }

      before { post v1_box_invitations_path(box_id: box1.id), params: params }

      it { is_expected.to eq(401) }
      it { assert_schema_conform }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { post v1_box_invitations_path(box_id: box1.id), params: params, headers: { authorization: "Bearer #{token(user1)}" } }

        it { is_expected.to eq(201) }
        it { assert_schema_conform }
      end

      context 'with other\'s box' do
        subject { response.status }

        before do
          post v1_box_invitations_path(box_id: box2.id), params: params, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end

      context 'with unpersisted user' do
        subject { response.status }

        before do
          post v1_box_invitations_path(box1), params: unpersisted_user, headers: { authorization: "Bearer #{token(user1)}" }
        end

        it { is_expected.to eq(400) }
        it { assert_schema_conform }
      end
    end
  end
end
