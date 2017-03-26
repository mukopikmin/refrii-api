class Food < ApplicationRecord
  belongs_to :room
  belongs_to :unit
end
