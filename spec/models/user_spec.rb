# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.new' do
    context 'with same email, different provider' do
      email = 'test@test.com'
      let!(:google_user) { create(:google_user, email: email) }
      let(:user) { build(:twitter_user, email: email) }

      it 'returns true on save' do
        expect(user.save).to be_truthy
      end
    end

    context 'with same email and provider' do
      email = 'test@test.com'
      let!(:google_user) { create(:google_user, email: email) }
      let(:user) { build(:google_user, email: email) }

      it 'returns false on save' do
        expect(user.save).to be_falsey
      end
    end
  end

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

  describe '#avatar_exists?' do
    context 'with avatar' do
      subject { create(:user, :with_avatar).avatar_exists? }

      it 'returns true' do
        is_expected.to be_truthy
      end
    end

    context 'without avatar' do
      subject { create(:user).avatar_exists? }

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

  describe '#unit_owns?' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:unit1) { create(:unit, user: user1) }

    context 'if have same labeled unit' do
      subject { user1.unit_owns?(unit1.label) }
      it { is_expected.to be_truthy }
    end

    context 'if do not have same labeled unit' do
      subject { user2.unit_owns?(unit1.label) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#base64_image' do
    context 'if image exists' do
      let(:user) { create(:user, :with_avatar) }

      it 'returns avatar encoded by base64' do
        expect(user.base64_avatar[:base64]).to be_a(String)
      end
    end

    context 'if no avatar exists' do
      let(:no_avatar_user) { create(:user) }

      it 'returns nil' do
        expect(no_avatar_user.base64_avatar).to be_nil
      end
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
    before(:each) do
      file = File.new(File.join('spec', 'resources', 'avatar.jpg'), 'rb')
      params = {
        file: file,
        size: file.size,
        content_type: 'image/jpeg'
      }
      allow(User).to receive(:download_image).and_return(params)
    end

    let(:auth) do
      Hashie::Mash.new(JSON.parse(File.read(File.join('spec', 'mocks', 'google_oauth.json'))))
    end
    let(:user) { User.find_for_google(auth) }

    it 'returns database authorized user' do
      expect(user).to be_a(User)
      expect(user.provider).to eq('google')
    end
  end

  describe '.find_for_google_token' do
    let(:mock_response) do
      JSON.parse(File.read(File.join('spec', 'mocks', 'tokeninfo.json'))).to_json
    end
    let(:email) { JSON.parse(mock_response)['email'] }
    let(:provider) { 'google' }

    context 'with valid token, existing user' do
      let(:user) { create(:user, email: email, provider: provider) }
      let(:authorized_user) do
        response = double
        allow(response).to receive(:code).and_return(200)
        allow(response).to receive(:body).and_return(mock_response)
        allow(RestClient).to receive(:get).and_return(response)
        User.find_for_google_token(JsonWebToken.payload(user))
      end

      it 'returns existing user' do
        expect(authorized_user.id).to eq(user.id)
      end
    end

    context 'with valid token, non-existing user' do
      let(:authorized_user) do
        response = double
        allow(response).to receive(:code).and_return(200)
        allow(response).to receive(:body).and_return(mock_response)
        allow(RestClient).to receive(:get).and_return(response)
        User.find_for_google_token(JsonWebToken.payload(build(:user)))
      end

      it 'returns existing user' do
        expect(authorized_user).to be_persisted
      end
    end

    context 'with invalid token' do
      let(:user) { build(:user) }
      before(:each) { allow(RestClient).to receive(:get).and_raise(RestClient::ExceptionWithResponse.new) }

      it 'raises error' do
        expect do
          User.find_for_google_token(JsonWebToken.payload(user))
        end.to raise_error(RestClient::ExceptionWithResponse)
      end
    end
  end

  describe '.find_for_auth0' do
    before(:each) do
      file = File.new(File.join('spec', 'resources', 'avatar.jpg'), 'rb')
      params = {
        file: file,
        size: file.size,
        content_type: 'image/jpeg'
      }
      allow(User).to receive(:download_image).and_return(params)
    end

    let(:auth) do
      Hashie::Mash.new(JSON.parse(File.read(File.join('spec', 'mocks', 'auth0_google_oauth.json'))))
    end
    let(:user) { User.find_for_google(auth) }

    it 'returns auth0 authorized user' do
      expect(user).to be_a(User)
      expect(user.provider).to eq('google')
    end
  end
end
