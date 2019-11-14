# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::InvitationsController', type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(delete: '/invitations/1').to route_to('v1/invitations#destroy', id: '1')
    end
  end
end
