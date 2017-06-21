require 'jsonapi/serializable'
require 'jsonapi/rails/action_controller'

class ApiController < ActionController::API
  def test_endpoint
    render jsonapi: User.first, include: params[:include], fields: params[:fields]
  end

  def jsonapi_rb
    render json: JSONAPI::Serializable::Renderer.render(
      User.first,
      include: params[:include],
      fields: params[:fields]
    ).to_hash
  end
end
