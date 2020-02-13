# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Boxes/Foods', type: :request do
  include Committee::Rails::Test::Methods

  let!(:box1) { create(:box, :with_owner) }
  let!(:box2) { create(:box, :with_owner) }
  let!(:box3) { create(:box, :with_owner) }

  before { Invitation.create(box: box3, user: user1) }

  pending "add some examples to (or delete) #{__FILE__}"
end
