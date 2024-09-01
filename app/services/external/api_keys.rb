# frozen_string_literal: true

# This helper module fetches and generates a secure hash for the external API.
#
# @see External::Api
#
module External
  module ApiKeys
    PRIVATE_KEY = Rails.application.credentials[:marvel][:private_key]
    PUBLIC_KEY = Rails.application.credentials[:marvel][:public_key]
    SECURE_HASH = Digest::MD5.hexdigest("1#{PRIVATE_KEY}#{PUBLIC_KEY}")
  end
end
