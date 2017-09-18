class SerializablePost < JSONAPI::Serializable::Resource
  type 'posts'

  attributes :title, :body,
             :created_at, :updated_at

  belongs_to :user
  has_many :comments
end
