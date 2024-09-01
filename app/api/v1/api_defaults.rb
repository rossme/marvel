# frozen_string_literal: true

# This module is used to define the default behavior for all API endpoints.
# @note This module is included in all API endpoints.
#
# @example
#   class Get < Grape::API
#     include V1::ApiDefaults
#   end
#
# @note The `current_user` helper method is defined here to retrieve the Warden object and fetch the user.
#

module V1
  module ApiDefaults
    extend ActiveSupport::Concern
    extend Grape::API::Helpers

    included do
      version "v1", using: :path
      prefix :api
      format :json
      content_type :json, "application/json"

      helpers do
        def authenticate!
          error!({ error: "401 Unauthorized" }, 401) unless current_user
        end

        def current_user
          warden = env["warden"]
          @current_user ||= warden.user
        end
      end
    end
  end
end
