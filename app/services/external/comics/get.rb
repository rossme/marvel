# frozen_string_literal: true

module External
  module Comics
    class Get
      include External::Api

      Result = Struct.new(:success?, :result, :errors)

      def initialize(page: 0)
        @page = page
      end

      def call
        response = fetch_cached_response(path: "api/comics/#{page}")

        Result.new(true, response, nil)
      rescue ExternalApiError => e
        Result.new(false, nil, e.message)
      end

      private

      attr_reader :page

      def endpoint
        "/comics"
      end

      # Move to a common module or base class
      def custom_params
        "#{order_by}#{pagination}"
      end

      # Move to a common module or base class
      def order_by
        "&orderBy=-onsaleDate"
      end

      # Move to a common module or base class
      def pagination
        "&offset=#{page}"
      end
    end
  end
end
