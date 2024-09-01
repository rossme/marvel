# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Comics::Character::Get, type: :request do
  describe 'GET /api/v1/comics/character' do
    subject(:do_request) { get '/api/v1/comics/character', params: params }
    let(:name) { 'deadpool' }
    let(:user) { create(:user) }

    let :params do
      {
        name: name,
        page: 0
      }
    end

    let(:make_api_request) do
      VCR.use_cassette('v1_comics_character') do
        do_request
      end
    end

    let(:make_api_request_failure) do
      VCR.use_cassette('v1_comics_character_failure') do
        do_request
      end
    end

    before do
      sign_in user
    end

    describe 'returns a list of comics by character name', :vcr do
      it 'returns a 200' do
        make_api_request

        expect(response.status).to eq(200)
      end
    end

    describe 'when the name is blank' do
      let(:name) { '' }

      it 'returns an error', :vcr do
        make_api_request_failure

        expect(response.status).to eq(400)
      end
    end


    describe 'when the service returns an error' do
      before do
        allow(External::Comics::Character::Get).to receive(:new).and_return(instance_double(External::Comics::Character::Get, call: OpenStruct.new(success?: false, errors: 'error')))
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

    describe 'when the user is not authenticated' do
      before do
        sign_out user
      end

      it 'returns a 401' do
        do_request

        expect(response.status).to eq(401)
      end
    end
  end
end
