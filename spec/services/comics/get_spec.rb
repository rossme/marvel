# frozen_string_literal: true

require 'rails_helper'

RSpec.describe External::Comics::Get, type: :request do
  subject(:do_request) { External::Comics::Get.new.call }

  describe 'Makes a successful external request to get comics' do
    it 'returns a successful response' do
      expect(do_request.success?).to eq(true)
    end

    it 'returns a list of comics' do
      expect(do_request.result).not_to be_empty
    end
  end

  describe 'Returns an error when the external request fails' do
    before do
      allow(External::Comics::Get).to receive(:new).and_return(
        instance_double(External::Comics::Get, call: OpenStruct.new(success?: false, errors: 'error')
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
