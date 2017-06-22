module Ams
  class ApiController < ActionController::API
    # https://github.com/rails-api/active_model_serializers/blob/0-10-stable/lib/active_model_serializers/register_jsonapi_renderer.rb#L44
    add :jsonapi do |json, options|
      json = serialize_jsonapi(json, options).to_json(options) unless json.is_a?(String)
      self.content_type ||= Mime[:jsonapi]
      self.response_body = json
    end

    def test_endpoint
      render jsonapi: User.first, include: params[:include], fields: params[:fields]
    end
  end
end
