
require 'active_model_serializers/register_jsonapi_renderer'
module Ams
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
    include ActiveModelSerializers::Jsonapi::ControllerSupport

    def test_endpoint
      render json: ActiveModelSerializers::SerializableResource.new(
        User.first,
        include: params[:include],
        fields: params[:fields],
        adapter: :jsonapi
      ).as_json
    end
  end
end
