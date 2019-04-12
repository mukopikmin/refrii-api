# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PushToken, type: :model do
  describe '#exists?' do
    context 'with existing token' do
      subject { push_token.exists? }

      let(:user) { create(:user) }
      let(:token) { 'this is dummy token' }
      let(:push_token) { build(:push_token, user: user, token: token) }

      before { create(:push_token, user: user, token: token) }

      it { is_expected.to be_truthy }
    end

    context 'with non-existing token' do
      subject { push_token.exists? }

      let(:user) { create(:user) }
      let(:push_token) { build(:push_token, user: user) }

      it { is_expected.to be_falsey }
    end
  end
end
