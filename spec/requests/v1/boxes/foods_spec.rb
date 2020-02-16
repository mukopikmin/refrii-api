# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes/Foods', type: :request do
  include Committee::Rails::Test::Methods

  let(:box) { create(:box, :with_owner) }
  let(:user) { box.owner }
  let(:invited_box) { create(:box, :with_owner) }
  let(:invisible_box) { create(:box, :with_owner) }
  let(:headers) { { authorization: "Bearer #{token(user)}" } }

  before { Invitation.create(box: invited_box, user: user) }

  describe 'GET /boxes/:id/foods' do
    context 'without authentication' do
      subject { response.status }

      before { get v1_box_foods_path(box) }

      it { is_expected.to eq(401) }
      it { assert_response_schema_confirm }
    end

    context 'with authentication' do
      context 'with own box' do
        subject { response.status }

        before { get v1_box_foods_path(box), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with invited box' do
        subject { response.status }

        before { get v1_box_foods_path(invited_box), headers: headers }

        it { is_expected.to eq(200) }
        it { assert_response_schema_confirm }
      end

      context 'with other\'s box' do
        subject { response.status }

        before { get v1_box_foods_path(invisible_box), headers: headers }

        it { is_expected.to eq(404) }
        it { assert_response_schema_confirm }
      end
    end
  end
end
