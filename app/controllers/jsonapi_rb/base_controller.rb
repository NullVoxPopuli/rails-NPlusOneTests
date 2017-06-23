
require 'jsonapi/serializable'

module JsonapiRb
  class BaseController < ActionController::Base
    include JsonapiEndpoints
  end
end
