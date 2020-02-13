# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Food, type: :model do
  describe '.all_with_invited' do
    subject { described_class.all_with_invited(user1).size }

    let(:food1) { create(:food, :with_box_user_unit) }
    let(:food2) { create(:food, :with_box_user_unit) }
    let(:user1) { food1.box.owner }

    before { Invitation.create(box: food2.box, user: user1) }

    it { is_expected.to eq(2) }
  end

  describe '#assignable_units' do
    subject { food.assignable_units.size }

    let(:food) { create(:food, :with_box_user_unit) }
    let(:user) { food.box.owner }

    before { create(:unit, user: user) }

    it { is_expected.to eq(2) }
  end

  describe '#revert' do
    let(:food) { create(:food, :with_box_user_unit) }

    context 'with versions' do
      subject { food.revert }

      before { food.update(name: 'after food') }

      it { is_expected.to be_truthy }
    end

    context 'with no versions' do
      subject { food.revert }

      it { is_expected.to be_falsey }
    end
  end
end
