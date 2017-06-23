
require 'active_model_serializers/register_jsonapi_renderer'
module Ams
  class BaseController < ActionController::Base
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
