module AmsEndpoints
  def test_endpoint
    render_data(User.first)
  end

  def test_manual_eagerload
    render_data(User.includes(posts: [:comments]).first)
  end


  def render_data(data)
    render json: ActiveModelSerializers::SerializableResource.new(
      data,
      include: params[:include],
      fields: params[:fields],
      adapter: :json_api
    ).as_json
  end
end
