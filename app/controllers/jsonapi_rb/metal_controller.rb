
require 'jsonapi/serializable'
require 'jsonapi/rails/action_controller'

module JsonapiRb
  class MetalController < ActionController::Metal
    include AbstractController::Rendering
    # ActionController::API.without_modules(
    #   :ForceSSL,
    #   :UrlFor,
    #   :DataStreaming,
    #   :Instrumentation,
    #   :ParamsWrapper,
    #   :Rescue,
    #   :'AbstractController::Callbacks',
    #   :StrongParameters,
    #   :ConditionalGet
    # ).each do |left|
    #   include left
    # end

    include(::ActionController::Serialization)

    def test_endpoint
      render json: JSONAPI::Serializable::Renderer.render(
        User.first,
        include: params[:include],
        fields: params[:fields]
      )
    end
  end
end
