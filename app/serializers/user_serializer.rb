class UserSerializer < ActiveModel::Serializer
  attributes :id, :authorized_id, :token
end
