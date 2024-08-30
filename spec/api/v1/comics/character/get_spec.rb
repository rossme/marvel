# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Comics::Character::Get, type: :request do
  describe 'GET /api/v1/comics/character' do
    subject(:do_request) { get '/api/v1/comics/character', params: params }
    let(:current_user) { create(:user) }
    let(:name) { 'deadpool' }

    let :params do
      {
        name: name,
        page: 0
      }
    end

    describe 'returns a list of comics by character name' do
      it 'returns a 200' do
        do_request

        expect(response.status).to eq(200)
      end
    end

    describe 'when the name does not exist' do
      let(:name) { 'batman' }

      it 'returns a 400' do
        do_request

        expect(response.status).to eq(400)
      end

      it 'returns an error message' do
        do_request

        expect(JSON.parse(response.body)['error']).to eq('Character not found')
      end
    end

    describe 'returns an error' do
      it 'returns a 400' do
        allow(External::Comics::Character::Get).to receive(:new).and_return(instance_double(External::Comics::Character::Get, call: OpenStruct.new(success?: false, errors: 'error')))

        do_request

        expect(response.status).to eq(400)
      end
    end
  end
end
