require 'rails_helper'

RSpec.describe 'API V1 Routes', type: :routing do
  it 'routes to #index for data' do
    expect(get: '/api/v1/data').to route_to(controller: 'api/v1/scrapes', action: 'index')
  end
end
