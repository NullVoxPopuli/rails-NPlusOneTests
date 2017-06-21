class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'


  attributes :id,
             :first_name, :last_name, :birthday,
             :created_at, :updated_at

  has_many :posts
end
