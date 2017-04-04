class Invitation < ApplicationRecord
  belongs_to :box
  belongs_to :user
end
