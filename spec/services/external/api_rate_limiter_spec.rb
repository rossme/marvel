# frozen_string_literal: true

require "rails_helper"

RSpec.describe External::ApiRateLimiter do
  let(:middleware) { described_class.new(nil, params) }
  let(:cache_key) { "user_#{user_id}_api_limiter_cache" }
  let(:params) { { cache_key: cache_key } }
  let(:user_id) { 3231 }

  describe "#on_request" do
    context "when the request count is less than the API rate limit" do
      it "increments the request count" do
        expect(Rails.cache).to receive(:fetch).with(cache_key).and_return(999)
        expect(Rails.cache).to receive(:write).with(cache_key, 1000, expires_in: 24.hours)
        expect(Rails.logger).to receive(:info).with("API request count: 1000, cache_key: user_3231_api_limiter_cache")

        middleware.on_request(nil)
      end
    end

    context "when the request count is equal to the API rate limit" do
      it "raises an error" do
        expect(Rails.cache).to receive(:fetch).with(cache_key).and_return(1000)
        expect { middleware.on_request(nil) }.to raise_error(Faraday::Error, "API rate limit exceeded for user cache user_3231_api_limiter_cache")
      end
    end
  end
end
