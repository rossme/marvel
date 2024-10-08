# frozen_string_literal: true

require 'rails_helper'

RSpec.describe External::Comics::Get, type: :request do
  subject(:do_request) { External::Comics::Get.new(page:, user_id:).call }
  let(:page) { 0 }
  let(:user_id) { 3231 }

  let(:make_api_request) do
    VCR.use_cassette('v1_comics') do
      do_request
    end
  end

  describe 'Makes a successful external request to get comics' do
    before do
      make_api_request
    end

    it 'returns a successful response', :vcr do
      expect(do_request.success?).to eq(true)
    end

    it 'returns a list of comics', :vcr do
      expect(do_request.result).not_to be_empty
    end
  end

  describe 'Returns an error when the external request fails' do
    before do
      allow(External::Comics::Get).to receive(:new).and_return(
        instance_double(External::Comics::Get, call: OpenStruct.new(success?: false, result: nil, errors: 'error')
      ))
    end

    it 'returns an unsuccessful response' do
      expect(do_request.success?).to eq(false)
    end

    it 'returns an error message' do
      expect(do_request.errors).not_to be_empty
    end
  end
end
