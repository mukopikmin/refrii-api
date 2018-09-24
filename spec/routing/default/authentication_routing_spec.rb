# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::AuthenticationController", type: :routing do
  describe 'routing' do
    it 'routes to #local' do
      expect(post: '/auth/local').to route_to("#{version}/authentication#local")
    end

    it 'routes to #google' do
      expect(get: '/auth/google/callback').to route_to("#{version}/authentication#google")
    end

    it 'routes to #google_token' do
      expect(get: '/auth/google/token').to route_to("#{version}/authentication#google_token")
    end

    it 'routes to #auth0' do
      expect(get: '/auth/auth0/callback').to route_to("#{version}/authentication#auth0")
    end
  end
end
