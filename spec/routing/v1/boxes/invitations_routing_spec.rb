# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Boxes::InvitationsController', type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/boxes/1/invitations').to route_to('v1/boxes/invitations#create', box_id: '1')
    end
  end
end
