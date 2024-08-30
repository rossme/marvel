# frozen_string_literal: true

require 'rails_helper'

RSpec.describe External::Comics::Character::Get, type: :request do
  subject(:do_request) { External::Comics::Character::Get.new(name: name, page:, user_id:).call }
  let(:name) { 'deadpool' }
  let(:page) { 0 }
  let(:user_id) { 3231 }
  let(:character_id) { 118953 }

  describe 'Makes a successful request to get comics' do
    it 'returns a successful response' do
      expect(do_request.success?).to eq(true)
    end

    it 'returns a list of comics' do
      expect(do_request.result).not_to be_empty
    end

    it 'assigns the character id' do
      expect(do_request.result.first.dig(:id)).to eq(character_id)
    end
  end

  describe 'Returns an error when the external request fails' do
    before do
      allow(External::Comics::Character::Get).to receive(:new).and_return(
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
