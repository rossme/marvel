# frozen_string_literal: true

module V1
  module Comics
    class Get < Grape::API
      include V1::ApiDefaults

      resource "comics" do
        desc "Returns a list of comics"
        get do
          request = External::Comics::Get.new.call

          request.success? ? request.result : error!(request.errors, 400)
        end
      end
    end
  end
end
