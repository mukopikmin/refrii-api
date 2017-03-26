class User < ApplicationRecord
  has_secure_password

  has_many :boxes, class_name: Box, foreign_key: 'owner_id'
  has_many :units
end
