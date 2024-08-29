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
        conn.use :http_cache, store: Rails.cache, logger: Rails.logger
        conn.headers["Content-Type"] = "application/json"
        conn.request :url_encoded
        conn.adapter Faraday.default_adapter
        conn.options.timeout = 90
      end
    rescue ExternalApiError => e
      Rails.logger.error("Error connecting to the API: #{e}")

      raise e
    end

    private

    def get_request
      request = connection.get("#{complete_url}")

      return request if request.status == 200

      raise ExternalApiError, "Error connecting to the API: #{request.status}"
    end

    def complete_url
      "#{BASE_URL}#{endpoint}#{query_params}"
    end

    def make_request
      parse_response(get_request)
    end

    def query_params
      "?ts=#{1}&apikey=#{public_key}&hash=#{generate_secure_hash}#{custom_params}"
    end

    def generate_secure_hash
      @_generate_secure_hash ||= Digest::MD5.hexdigest("#{1}#{private_key}#{public_key}")
    end

    def marvel_keys
      @_marvel_keys ||= Rails.application.credentials.dig("marvel")
    end

    def private_key
      marvel_keys[:private_key]
    end

    def public_key
      marvel_keys[:public_key]
    end

    def parse_response(res)
      JSON.parse(res.body, symbolize_names: true)
    end

    def custom_params
      raise NotImplementedError
    end

    def build_response
      results = make_request.dig(:data, :results)

      results.map do |result|
        {
          id: result[:id],
          title: result[:title],
          thumbnail: build_image_path(result)
        }
      end
    end

    def build_image_path(result)
      # If a thumbnail path is not available from the Marvel API, return a placeholder image
      if result[:thumbnail][:path].include?("image_not_available")
        return "/assets/marvel_placeholder.jpg"
      end

      result[:thumbnail][:path] + "." + result[:thumbnail][:extension]
    end

    class ExternalApiError < Faraday::Error; end
  end
end
