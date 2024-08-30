# frozen_string_literal: true

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

      # Move to a common module or base class
      def order_by
        @_order_by ||= "&orderBy=-onsaleDate"
      end

      # Move to a common module or base class
      def pagination
        @_pagination ||= "&offset=#{offset}"
      end

      # Move to a common module or base class
      def offset
        @_offset ||= page * 20 # 20 is the default offset limit (20 items per page)
      end
    end
  end
end
