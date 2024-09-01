# frozen_string_literal: true

# This service is responsible for limiting the number of API requests a user can make
#
# @example
#   External::ApiRateLimiter.new(cache_key: 'user_3231').on_request(env)
#
# @param [String] cache_key the user's unique cache key
#
# @see External::Api
#

module External
  class ApiRateLimiter < Faraday::Middleware
    include External::Api

    API_RATE_LIMIT = 1000
    TIME_WINDOW = 24.hours

    def on_request(_env)
      @cache_key = options[:cache_key]
      @request_count = Rails.cache.fetch(@cache_key) || 0

      raise ExternalApiError, "API rate limit exceeded for user cache #{@cache_key}" if exceeds_api_rate_limit?

      increment_api_request_count
      logger.info "API request count: #{@request_count}, cache_key: #{@cache_key}"
    rescue ExternalApiError => e
      logger.error("Error connecting to the API: #{e}")

      raise e
    end

    def exceeds_api_rate_limit?
      @request_count >= API_RATE_LIMIT
    end

    def increment_api_request_count
      Rails.cache.write(@cache_key, @request_count += 1, expires_in: TIME_WINDOW)
    end
  end
end
