# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes', type: :request do
  include Committee::Rails::Test::Methods

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:box1) { create(:box, owner: user1) }
  let!(:box2) { create(:box, owner: user2) }
  let!(:box3) { create(:box, owner: user2) }

  before { Invitation.create(box: box3, user: user1) }

  pending "add some examples to (or delete) #{__FILE__}"
end
