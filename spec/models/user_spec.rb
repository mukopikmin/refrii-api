require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid_password?' do
    let(:user) { create(:user) }
    let(:password) { attributes_for(:user)[:password] }

    context 'with valid password' do
      subject { user.valid_password?(password) }

      it 'returns truthy' do
        is_expected.to be_truthy
      end
    end

    context 'with invalid password' do
      subject { user.valid_password?("INVALID PASSWORD #{password}") }

      it 'returns falsey' do
        is_expected.to be_falsey
      end
    end
  end

  describe '#local_user?' do
    context 'with local authorized user' do
      subject { create(:local_user).local_user? }

      it 'returns true' do
        is_expected.to be_truthy
      end
    end

    context 'with oauth authorized user' do
      subject { create(:google_user).local_user? }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end
  end

  describe '#has_avatar?' do
    context 'with avatar' do
      subject { create(:user, :with_avatar).has_avatar? }

      it 'returns true' do
        is_expected.to be_truthy
      end
    end

    context 'without avatar' do
      subject { create(:user).has_avatar? }

      it 'returns false' do
        is_expected.to be_falsey
      end
    end
  end

  describe '#invited_boxes' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:box) { create(:box, owner: user1) }
    let!(:invitation) { Invitation.create(user: user2, box: box) }
    subject { user2.invited_boxes }

    it 'returns invited boxes' do
      is_expected.to eq([box])
    end
  end

  describe '#has_unit_labeled_with' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:unit1) { create(:unit, user: user1) }

    context 'if have same labeled unit' do
      subject { user1.has_unit_labeled_with(unit1.label) }
      it { is_expected.to be_truthy }
    end

    context 'if do not have same labeled unit' do
      subject { user2.has_unit_labeled_with(unit1.label) }
      it { is_expected.to be_falsey }
    end
  end

  describe '.find_for_database_authentication' do
    let(:user) { create(:user) }

    context 'if exists' do
      let(:condition) { { email: user.email } }
      subject { User.find_for_database_authentication(condition) }

      it 'returns database user' do
        is_expected.to eq(user)
      end
    end

    context 'if not exists' do
      let(:condition) { { email: "nonexists-#{user.email}" } }
      subject { User.find_for_database_authentication(condition) }

      it 'returns nil' do
        is_expected.to be_nil
      end
    end
  end

  describe '.find_for_google' do
    let(:auth) do
      {
        info: {
          name: 'test user',
          email: 'test@test.com'
        }
      }
    end
    let(:user) { User.find_for_google(auth) }

    it 'returns google authorized user' do
      expect(user).to be_a(User)
      expect(user.provider).to eq('google')
    end
  end
end
