# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Comics::Get, type: :request do
  describe 'GET /api/v1/comics' do
    subject(:do_request) { get '/api/v1/comics', params: {} }

    describe 'returns a list of comics' do
      it 'returns a 200' do
        do_request

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
