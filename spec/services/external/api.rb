# frozen_string_literal: true

require "rails_helper"

RSpec.describe External::Api do
  let(:api_module) { MockApiModule.new }
  let(:url) { 'https://gateway.marvel.com/v1/public' }
  let(:endpoint) { '/comics' }
  let(:user_id) { 1 }
  let(:marvel_keys) {
    {
      public_key: '1111',
      private_key: '2222'
    }
  }
  let(:response) { instance_double(Faraday::Response, status: 200) }

  describe '#connection' do
    before do
      allow(Faraday).to receive(:new).and_return(Faraday.new)
    end

    it 'returns a Faraday connection' do
      expect(api_module.connection).to be_a(Faraday::Connection)
    end
  end

  describe '#BASE_URL' do
    it 'returns the base url' do
      expect(External::Api::BASE_URL).to eq(url)
    end
  end

  describe '#marvel_keys' do
    before do
      allow(api_module).to receive(:marvel_keys).and_return(marvel_keys)
    end

    it "returns the marvel_keys credentials", :private do
      expect(api_module.send(:marvel_keys)).to eq(marvel_keys)
    end
  end

  describe '#user_api_limiter_cache_key' do
    before do
      allow(api_module).to receive(:user_id).and_return(user_id)
    end

    it 'returns the user api limiter cache key' do
      expect(api_module.send(:user_api_limiter_cache_key)).to eq("user_#{user_id}_api_limiter_cache")
    end
  end

  describe '#generate_secure_hash' do
    before do
      allow(api_module).to receive(:private_key).and_return(marvel_keys[:private_key])
      allow(api_module).to receive(:public_key).and_return(marvel_keys[:public_key])
    end

    it 'returns the secure hash' do
      expect(api_module.send(:generate_secure_hash)).to eq(Digest::MD5.hexdigest("1#{marvel_keys[:private_key]}#{marvel_keys[:public_key]}"))
    end
  end

  describe '#custom_params' do
    it 'raises an error' do
      expect { api_module.send(:custom_params) }.to raise_error(NotImplementedError)
    end
  end
end

class MockApiModule
  include External::Api

  def user_id
    super
  end

  def endpoint
    '/comics'
  end
end
