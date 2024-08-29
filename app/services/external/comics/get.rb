# frozen_string_literal: true

module External
  module Comics
    class Get
      include External::Api

      Result = Struct.new(:success?, :result, :errors)

      def initialize; end

      def call
        # create an ETAG and pass it here as a UID?
        response = Rails.cache.fetch("foo", expires_in: 1.hour, skip_nil: true) do
          Rails.logger.info "Fetching comics from Marvel API"
          build_response
        end

        Result.new(true, response, nil)
      rescue StandardError => e
        Result.new(false, nil, e.message)
      end

      private

      attr_reader :character_id

      def endpoint
        "/comics"
      end

      def custom_params
        "&orderBy=onsaleDate"
      end
    end
  end
end
