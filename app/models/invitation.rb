class Invitation < ApplicationRecord
  belongs_to :box
  belongs_to :user

  validates_presence_of :box
  validates_presence_of :user
end
