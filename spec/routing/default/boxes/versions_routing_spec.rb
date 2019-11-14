# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::Boxes::VersionsController", type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/boxes/1/versions').to route_to("#{version}/boxes/versions#index", box_id: '1')
    end

    it 'routes to #create via POST' do
      expect(post: '/v1/boxes/1/versions').to route_to("#{version}/boxes/versions#create", box_id: '1')
    end
  end
end
