# frozen_string_literal: true

module V1
  module ApiDefaults
    extend ActiveSupport::Concern

    included do
      version "v1", using: :path
      prefix :api
      format :json
      content_type :json, "application/json"
    end
  end
end
