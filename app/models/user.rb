class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :comments
end
