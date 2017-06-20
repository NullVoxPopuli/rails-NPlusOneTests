class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :first_name, :last_name, :birthday

  has_many :posts
end
