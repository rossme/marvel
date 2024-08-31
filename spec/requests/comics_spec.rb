# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Comics", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }
    let(:root_path) { '/' }

    it "returns http success" do
      sign_in user

      get root_path

      expect(response.status).to eq(200)
    end
  end
end
