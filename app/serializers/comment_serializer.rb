class CommentSerializer < ActiveModel::Serializer
  attributes :id,
             :author, :comment

  belongs_to :post
end
