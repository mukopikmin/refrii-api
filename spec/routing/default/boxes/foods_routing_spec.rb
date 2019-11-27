# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::Boxes::FoodsController", type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/boxes/1/foods').to route_to("#{version}/boxes/foods#index", box_id: '1')
    end
  end
end
