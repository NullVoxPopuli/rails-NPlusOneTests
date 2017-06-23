module Ams
  class ApiController < ActionController::API
    def test_endpoint
      render json: ActiveModelSerializers::SerializableResource.new(
        User.first,
        include: params[:include],
        fields: params[:fields],
        adapter: :json_api
      ).as_json
    end
  end
end
