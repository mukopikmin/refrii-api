require 'rails_helper'

RSpec.describe 'Root', type: :request do
  describe 'GET /' do
    before(:each) { get root_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end
