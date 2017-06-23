require 'rails_helper'

RSpec.describe "Ams::Api", type: :request do
  describe "GET /ams/api" do
    it "doesn't error" do
      get '/ams/api'
      expect(response).to have_http_status(200)
    end
  end
end
