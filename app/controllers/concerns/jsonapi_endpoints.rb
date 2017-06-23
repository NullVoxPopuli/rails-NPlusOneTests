module JsonapiEndpoints
  def test_endpoint
    render_data(User.first)
  end

  def test_manual_eagerload
    render_data(User.includes(posts: [:comments]).first)
  end


  def render_data(data)
    json = JSONAPI::Serializable::Renderer.render(
      data,
      include: params[:include],
      fields: params[:fields] || [],
      class: SerializableUser

    )

    render json: json
  end
end
