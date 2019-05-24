# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.new' do
    context 'with same email, different provider' do
      let(:email) { 'test@test.com' }
      let(:user) { build(:twitter_user, email: email) }

      before { create(:google_user, email: email) }

      it 'returns true on save' do
        expect(user.save).to be_truthy
      end
    end

    context 'with same email and provider' do
      let(:email) { 'test@test.com' }
      let(:user) { build(:google_user, email: email) }

      before { create(:google_user, email: email) }

      it 'returns false on save' do
        expect(user.save).to be_falsey
      end
    end
  end

  describe '#local_user?' do
    context 'with local authorized user' do
      subject { create(:local_user).local_user? }

      it { is_expected.to be_truthy }
    end

    context 'with oauth authorized user' do
      subject { create(:google_user).local_user? }

      it { is_expected.to be_falsey }
    end
  end

  describe '#invited_boxes' do
    let(:boxes) { user2.invited_boxes }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:box) { create(:box, owner: user1) }

    before { Invitation.create(user: user2, box: box) }

    it 'returns invited boxes' do
      expect(boxes).to eq([box])
    end
  end

  describe '#unit_owns?' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:unit1) { create(:unit, user: user1) }

    context 'when have same labeled unit' do
      subject { user1.unit_owns?(unit1.label) }

      it { is_expected.to be_truthy }
    end

    context 'when do not have same labeled unit' do
      subject { user2.unit_owns?(unit1.label) }

      it { is_expected.to be_falsey }
    end
  end
end
