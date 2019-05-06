# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::RootController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1').to route_to('v1/root#index')
    end
  end
end
