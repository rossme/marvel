# frozen_string_literal: true

# This service is responsible for fetching a character's comics from the external API
#
# @example
#   External::Comics::Character::Get.new(name: 'deadpool', page: 0, user_id: 3231).call
#
# @param [String] name the character's name
# @param [Integer] page the page number
# @param [Integer] user_id the user's id
#
# @see V1::Comics::Character::Get
#

module External
  module Comics
    module Character
      class Get
        include External::Api

        Result = Struct.new(:success?, :result, :errors)

        def initialize(name:, page: 0, user_id: nil)
          @name = name.downcase
          @page = page
          @user_id = user_id
        end

        def call
          get_character_id
          get_character_comics

          Result.new(true, comics, nil)
        rescue ExternalApiError => e
          Result.new(false, nil, e.message)
        end

        private

        attr_reader :character_id, :comics, :name, :page, :user_id

        def get_character_id
          response = fetch_cached_response(path: "api/comics/character/#{name}/#{page}", search: true)

          @character_id = response.first.dig(:id) if valid_response?(response&.first)
        end

        def valid_response?(response)
          return true if response&.dig(:id) && response&.dig(:name)&.downcase == name

          raise "Character not found"
        end

        def get_character_comics
          response = fetch_cached_response(path: "api/comics/character/#{@character_id}/#{page}")

          @comics = response
        end

        def endpoint
          @character_id ? "/characters/#{@character_id}/comics" : "/characters"
        end

        def custom_params
          if @character_id
            "#{order_by}#{pagination}"
          else
            "&name=#{name}"
          end
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
          @_offset ||= page * 20 # 20 is the default response limit
        end
      end
    end
  end
end
