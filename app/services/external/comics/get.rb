# frozen_string_literal: true

# This service is responsible for fetching comics from the external API
#
# @example
#   External::Comics::Get.new(page: 0, user_id: 3231).call
#
# @param [Integer] page the page number
# @param [Integer] user_id the user's id
#
# @see V1::Comics::Get
#

module External
  module Comics
    class Get
      include External::Api

      Result = Struct.new(:success?, :result, :errors)

      def initialize(page: 0, user_id: nil)
        @page = page
        @user_id = user_id
      end

      def call
        response = fetch_cached_response(path: "api/comics/#{page}")

        Result.new(true, response, nil)
      rescue ExternalApiError => e
        Result.new(false, nil, e.message)
      end

      private

      attr_reader :page, :user_id

      def endpoint
        @_endpoint ||= "/comics"
      end

      # Move to a common module or base class
      def custom_params
        @_custom_params ||= "#{order_by}#{pagination}"
      end
    end
  end
end
