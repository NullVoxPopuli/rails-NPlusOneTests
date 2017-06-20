class BaseController < ActionController::Base
  def test_endpoint
    render jsonapi: User.first, include: params[:include], fields: params[:fields]
  end
end
