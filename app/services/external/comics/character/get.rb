# frozen_string_literal: true

module External
  module Comics
    module Character
      class Get
        include External::Api

        Result = Struct.new(:success?, :result, :errors)

        def initialize(name:)
          @name = name
        end

        def call
          get_character_id
          get_character_comics

          Result.new(true, comics, nil)
        rescue StandardError => e
          Result.new(false, nil, e.message)
        end

        private

        attr_reader :name, :character_id, :comics

        def get_character_id
          character_data = make_request.dig(:data, :results)
          if make_request.dig(:data, :results).present?
            @character_id = character_data.first[:id]
          else
            raise "Character not found"
          end
        end

        def get_character_comics
          @comics = build_response
        end

        def endpoint
          @character_id ? "/characters/#{@character_id}/comics" : "/characters"
        end

        def custom_params
          @character_id ? "&orderBy=onsaleDate" : "&name=#{name}"
        end
      end
    end
  end
end
