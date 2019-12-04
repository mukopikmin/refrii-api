# frozen_string_literal: true

require 'rails_helper'

version = 'v1'

RSpec.describe "#{version.upcase}::Users::PushTokensController", type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/v1/users/1/push_tokens').to route_to("#{version}/users/push_tokens#create", user_id: '1')
    end
  end
end
