# frozen_string_literal: true

module V1
  module Comics
    module Character
      class Get < Grape::API
        include V1::ApiDefaults

        before do
          authenticate!
        end

        resource "comics/character" do
          desc "Returns a list of comics by character name"

          params do
            requires :name, type: String, desc: "Character name"
            optional :page, type: Integer, desc: "Page number", default: 0
          end

          get do
            request = External::Comics::Character::Get.new(name: params[:name], page: params[:page], user_id: current_user.id).call

            request.success? ? request.result : error!(request.errors, 400)
          end
        end
      end
    end
  end
end
