# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShopPlan, type: :model do
  let(:food1) { create(:food, :with_box_user_unit) }
  let(:food2) { create(:food, :with_box_user_unit) }
  let!(:plan1) { create(:shop_plan, food: food1) }
  let!(:plan2) { create(:shop_plan, food: food2) }
  let(:user1) { food1.box.owner }
  let(:user2) { food2.box.owner }

  describe '.all_with_invited' do
    context 'without invitation' do
      subject { described_class.all_with_invited(user1) }

      it { is_expected.to eq([plan1]) }
    end

    context 'with invitations' do
      subject { described_class.all_with_invited(user1) }

      before { Invitation.create(box: food2.box, user: user1) }

      it { is_expected.to eq([plan1, plan2]) }
    end
  end

  describe '#accessible_for?' do
    context 'with own shop plans' do
      subject { plan1.accessible_for?(user1) }

      it { is_expected.to be_truthy }
    end

    context 'with other\'s shop plans' do
      subject { plan1.accessible_for?(user2) }

      it { is_expected.to be_falsey }
    end

    context 'with shop plans for foods in invited box' do
      subject { plan2.accessible_for?(user1) }

      before { Invitation.create(box: food2.box, user: user1) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#update_or_complete' do
    context 'without change of done status' do
      subject { plan1.attributes.symbolize_keys }

      let(:params) { attributes_for(:shop_plan) }

      before { plan1.update_or_complete(params) }

      it { is_expected.to include(params) }
    end

    context 'with change of done status' do
      subject { plan1.attributes.symbolize_keys }

      let!(:amount) { food1.amount }
      let(:params) { attributes_for(:shop_plan, :completed) }

      before { plan1.update_or_complete(params) }

      it { is_expected.to include(params) }

      it 'updates amount of food' do
        expect(amount + params[:amount]).to eq(food1.amount)
      end
    end
  end
end
