# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::InvitationsController", type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(delete: '/invitations/1').to route_to("#{version}/invitations#destroy", id: '1')
    end
  end
end
