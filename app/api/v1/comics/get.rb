# frozen_string_literal: true

module V1
  module Comics
    class Get < Grape::API
      include V1::ApiDefaults

      before do
        authenticate!
      end

      resource "comics" do
        desc "Returns a list of comics"

        params do
          optional :page, type: Integer, desc: "Page number", default: 0
        end

        get do
          request = External::Comics::Get.new(page: params[:page], user_id: current_user.id).call

          request.success? ? request.result : error!(request.errors, 400)
        end
      end
    end
  end
end
