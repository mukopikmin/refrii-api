class Room < ApplicationRecord
  belongs_to :box
  has_many :foods
end
