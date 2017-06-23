module Ams
  class MetalController < ActionController::Metal
    include AbstractController::Rendering
    include(::ActionController::Serialization)

    include AmsEndpoints
  end
end
