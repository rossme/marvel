# frozen_string_literal: true

module External
  class ApiRateLimiter < Faraday::Middleware

    API_RATE_LIMIT = 1000
    TIME_WINDOW = 24.hours

    def on_request(_env)
      @cache_key = options[:cache_key]
      @request_count = Rails.cache.fetch(@cache_key) || 0

      raise Faraday::Error, "API rate limit exceeded for user cache #{@cache_key}" if exceeds_api_rate_limit?

      increment_api_request_count
      Rails.logger.info "API request count: #{@request_count}, cache_key: #{@cache_key}"
    end

    def exceeds_api_rate_limit?
      @request_count > API_RATE_LIMIT
    end

    def increment_api_request_count
      Rails.cache.write(@cache_key, @request_count += 1, expires_in: TIME_WINDOW)
    end
  end
end
