# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShopPlan, type: :model do
  describe '.all_with_invited' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:box1) { create(:box, owner: user1) }
    let(:box2) { create(:box, owner: user2) }
    let(:unit1) { create(:unit, user: user1) }
    let(:unit2) { create(:unit, user: user2) }
    let(:food1) { create(:food, unit: unit1, box: box1, created_user: user1, updated_user: user1) }
    let(:food2) { create(:food, unit: unit2, box: box2, created_user: user2, updated_user: user2) }
    let!(:plan1) { create(:shop_plan, food: food1) }
    let!(:plan2) { create(:shop_plan, food: food2) }

    context 'without invitation' do
      subject { ShopPlan.all_with_invited(user1) }

      it { is_expected.to eq([plan1]) }
    end

    context 'with invitations' do
      subject { ShopPlan.all_with_invited(user1) }

      before { Invitation.create(box: box2, user: user1) }

      it { is_expected.to eq([plan1, plan2]) }
    end
  end
end
