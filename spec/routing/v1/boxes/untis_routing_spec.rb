# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Boxes::UnitsController', type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/boxes/1/units').to route_to('v1/boxes/units#index', box_id: '1')
    end
  end
end
