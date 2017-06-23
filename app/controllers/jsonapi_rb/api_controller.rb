require 'jsonapi/serializable'

module JsonapiRb
  class ApiController < ActionController::API
    include JsonapiEndpoints
  end
end
