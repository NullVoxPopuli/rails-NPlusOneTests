class MetalController < ActionController::Metal
  # Include enough middleware to render jsonapi
  include AbstractController::Rendering        # enables rendering
  include ActionController::Renderers::All
  include ActionController::ApiRendering
  include ActionController::BasicImplicitRender
  include ActionController::StrongParameters
  include ActionController::MimeResponds

  include AbstractController::Callbacks


  def test_endpoint
    render jsonapi: User.first, include: params[:include], fields: params[:fields]
  end
end
