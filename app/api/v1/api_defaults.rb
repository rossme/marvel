# frozen_string_literal: true

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
        def current_user
          warden = env["warden"]
          @current_user ||= warden.authenticate
        end
      end
    end
  end
end
