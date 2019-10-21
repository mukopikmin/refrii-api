# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::Foods::NoticesController", type: :routing do
  describe 'routing' do
    it 'routes to #destroy' do
      expect(delete: '/notices/1').to route_to("#{version}/notices#destroy", id: '1')
    end
  end
end
