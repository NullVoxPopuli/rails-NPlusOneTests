
require 'jsonapi/serializable'

module JsonapiRb
  class BaseController < ActionController::Base
    def test_endpoint
      render json: JSONAPI::Serializable::Renderer.render(
        User.first,
        include: params[:include],
        fields: params[:fields]
      ).to_hash
    end
  end
end
