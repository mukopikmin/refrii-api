require 'rails_helper'

RSpec.describe Unit, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:unit1) { create(:unit, user: user1) }
  let!(:unit2) { create(:unit, user: user2) }

  describe '.new' do
    label = 'labe;'
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    context 'with same label, different user' do
      let!(:existing_unit) { create(:unit, label: label, user: user1) }
      let(:unit) { build(:unit, label: label, user: user2) }

      it 'returns true on save' do
        expect(unit.save).to be_truthy
      end
    end

    context 'with same label and user' do
      let!(:existing_unit) { create(:unit, label: label, user: user1) }
      let(:unit) { build(:unit, label: label, user: user1) }

      it 'returns false on save' do
        expect(unit.save).to be_falsey
      end
    end
  end

  describe 'scope' do
    describe 'owned_by' do
      subject(:units) { Unit.owned_by(user1) }
      it { is_expected.to eq([unit1]) }
    end
  end

  describe '#is_owned_by' do
    context 'with unit owned' do
      subject { unit1.is_owned_by(user1) }
      it { is_expected.to be_truthy }
    end

    context 'with unit not owned' do
      subject { unit1.is_owned_by(user2) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#is_inuse?' do
    context 'with units not referenced by foods' do
      subject { unit1.is_inuse? }
      it { is_expected.to be_falsey }
    end

    context 'with units referenced by foods' do
      let(:box) { create(:box, owner: user1) }
      let!(:food) { create(:food, unit: unit1, box: box, created_user: user1, updated_user: user1) }

      subject { unit1.is_inuse? }
      it { is_expected.to be_truthy }
    end
  end
end
