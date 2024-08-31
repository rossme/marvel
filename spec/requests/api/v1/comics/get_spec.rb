# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Comics::Get, type: :request do
  describe 'GET /api/v1/comics' do
    subject(:do_request) { get '/api/v1/comics', params: params }

    let(:make_api_request) do
      VCR.use_cassette('v1_comics') do
        do_request
      end
    end

    let(:user) { create(:user) }

    let(:params) do
      {
        page: 0
      }
    end

    before do
      sign_in user
    end

    describe 'returns a list of comics', :vcr do
      it 'returns a 200' do
        make_api_request

        expect(response.status).to eq(200)
      end
    end

    describe 'returns an error' do
      before do
        allow(External::Comics::Get).to receive(:new).and_return(instance_double(External::Comics::Get, call: OpenStruct.new(success?: false, errors: 'error')))
      end

      it 'returns a 400' do
        do_request

        expect(response.status).to eq(400)
      end

      it 'returns an error message' do
        do_request

        expect(JSON.parse(response.body)['error']).to eq('error')
      end
    end
  end
end
