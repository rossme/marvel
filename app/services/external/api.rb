# frozen_string_literal: true

# This Module includes helper methods for the Comics and Character service classes
#
# @example
#   include External::Api::Get
#
# @see External::Comics::Get
#

module External
  module Api
    extend ActiveSupport::Concern

    BASE_URL = "https://gateway.marvel.com/v1/public"

    def connection
      Faraday.new do |conn|
        conn.use ApiRateLimiter, cache_key: user_api_limiter_cache_key
        conn.headers["Content-Type"] = "application/json"
        conn.request :url_encoded
        conn.adapter Faraday.default_adapter
        conn.options.timeout = 40
        conn.response :logger, api_logger do | logger |
          logger.filter(/(apikey=|hash=)([^&]+)/, '\1[FILTERED]')
        end
      end
    rescue ExternalApiError => e
      api_logger.error("Error connecting to the API: #{e}")

      raise e
    end

    private

    def get_request
      request = connection.get("#{complete_url}")

      return request if request&.status == 200

      raise ExternalApiError, "Error connecting to the API: #{request&.status}"
    end

    def complete_url
      "#{BASE_URL}#{endpoint}#{query_params}"
    end

    def make_request
      parse_response(get_request)
    end

    def query_params
      "?ts=1&apikey=#{External::ApiKeys::PUBLIC_KEY}&hash=#{External::ApiKeys::SECURE_HASH}#{custom_params}"
    end

    def parse_response(res)
      JSON.parse(res.body, symbolize_names: true)
    end

    def custom_params
      raise NotImplementedError
    end

    def build_response(search: false)
      results = make_request.dig(:data, :results)
      return results if search

      results.map do |result|
        {
          id: result[:id],
          title: result[:title],
          thumbnail: build_image_path(result[:thumbnail])
        }
      end
    end

    def fetch_cached_response(path:, search: false)
      Rails.cache.fetch(path, expires_in: 1.hour, skip_nil: true) do
        api_logger.info "Cache miss, fetching external data from the Marvel API"
        build_response(search: search)
      end
    end

    def build_image_path(thumbnail)
      return placeholder_image_path if image_not_available?(thumbnail)

      thumbnail[:path] + "." + thumbnail[:extension]
    end

    def user_api_limiter_cache_key
      raise ExternalApiError, "A valid user must be logged in to track their API use" unless user_id

      "user_#{user_id}_api_limiter_cache"
    end

    def api_logger
      @_api_logger ||= ActiveSupport::TaggedLogging.new(Logger.new(STDOUT)).tagged("MARVEL_EXTERNAL_API")
    end

    def placeholder_image_path
      "/assets/marvel_placeholder.jpg"
    end

    def image_not_available?(thumbnail)
      thumbnail[:path].include?("image_not_available")
    end

    def order_by
      @_order_by ||= "&orderBy=-onsaleDate"
    end

    def pagination
      @_pagination ||= "&offset=#{offset}"
    end

    def offset
      @_offset ||= page * 20 # 20 objects per page
    end

    class ExternalApiError < Faraday::Error; end
  end
end
