
require 'rails_helper'

RSpec.describe "JsonapiRb::Api", type: :request do
  describe "GET /jsonapi/api" do
    it "doesn't error" do
      get '/jsonapi/api'
      expect(response).to have_http_status(200)
    end
  end
end
