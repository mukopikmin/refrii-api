class Food < ApplicationRecord
  belongs_to :box
  belongs_to :unit
end
