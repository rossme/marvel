# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApiDefaults', type: :request do
  include Rack::Test::Methods

  describe '#included do' do
    let(:warden) { double('Warden', user: user) }
    let(:user) { create(:user) }

    let(:make_api_request) do
      VCR.use_cassette('v1_comics') do
        get '/api/v1/comics'
      end
    end

    before do
      sign_in user
      make_api_request
    end

    it 'returns the current user via warden' do
      expect(last_request.env['warden'].user).to eq(user)
    end

    it 'returns the current api version' do
      expect(last_request.env['api.version']).to eq('v1')
    end
  end
end
