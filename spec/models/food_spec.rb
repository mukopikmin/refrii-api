require 'rails_helper'

RSpec.describe Food, type: :model do
  let(:user) { create(:user) }
  let(:box) { create(:box, user: user) }
  let(:unit) { create(:unit, user: user) }
  let(:food) { create(:food, :with_image, box: box, unit: unit, created_user: user, updated_user: user) }
  let(:no_image_food) { create(:food, box: box, unit: unit, created_user: user, updated_user: user) }

  describe '#has_image?' do
    context 'if image exists' do
      subject { food.has_image? }

      it 'returns true' do
        is_expected.to be_truthy
      end
    end

    context 'if no image exists' do
      subject { no_image_food.has_image? }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end
  end
end
