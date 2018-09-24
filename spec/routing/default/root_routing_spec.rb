# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::AuthenticationController", type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/').to route_to("#{version}/root#index")
    end
  end
end
