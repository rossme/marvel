# frozen_string_literal: true

module V1
  module ApiDefaults
    extend ActiveSupport::Concern

    included do
      version "v1", using: :path
      prefix :api
      format :json
      content_type :json, "application/json"

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!(message: e.message, status: 404)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        error!(message: e.message, status: 422)
      end
    end
  end
end
