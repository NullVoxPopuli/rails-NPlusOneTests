
  require 'active_model_serializers/register_jsonapi_renderer'
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
    render jsonapi: User.first, include: params[:include], fields: params[:fields]
  end
end
