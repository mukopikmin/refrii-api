# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::Boxes::InvitationsController", type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/boxes/1/invitations').to route_to("#{version}/boxes/invitations#create", box_id: '1')
    end
  end
end
