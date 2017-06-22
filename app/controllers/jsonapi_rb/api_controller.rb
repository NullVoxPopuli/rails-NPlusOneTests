require 'jsonapi/serializable'
require 'jsonapi/rails/action_controller'
module JsonapiRb
  class ApiController < ActionController::API
    # https://github.com/jsonapi-rb/jsonapi-rails/blob/master/lib/jsonapi/rails/railtie.rb
      RENDERERS = {
        jsonapi:       JSONAPI::Rails.rails_renderer(SuccessRenderer),
        jsonapi_error: JSONAPI::Rails.rails_renderer(ErrorRenderer)
      }.freeze

   RENDERERS.each do |key, renderer|
            add(key, &renderer)
          end
    def test_endpoint
      render jsonapi: JSONAPI::Serializable::Renderer.render(
        User.first,
        include: params[:include],
        fields: params[:fields]
      ).to_hash
    end
  end
end
