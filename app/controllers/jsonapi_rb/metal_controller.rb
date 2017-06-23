
require 'jsonapi/serializable'

module JsonapiRb
  class MetalController < ActionController::Metal
    include AbstractController::Rendering
    include(::ActionController::Serialization)

    include JsonapiEndpoints
  end
end
