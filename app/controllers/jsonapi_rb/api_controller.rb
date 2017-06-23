require 'jsonapi/serializable'
require 'jsonapi/rails/action_controller'

module JsonapiRb
  class ApiController < ActionController::API
    def test_endpoint
      json = JSONAPI::Serializable::Renderer.render(
        User.first,
        include: params[:include],
        fields: params[:fields] || [],
        class: SerializableUser

      )

      render json: json
    end
  end
end
