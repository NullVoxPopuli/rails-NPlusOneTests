class SerializableComment < JSONAPI::Serializable::Resource
  type 'comments'

  attributes :id,
             :author, :comment

  belongs_to :post
end
