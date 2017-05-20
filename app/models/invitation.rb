class Invitation < ApplicationRecord
  validates :box, presence: true
  validates :user, presence: true

  belongs_to :box
  belongs_to :user
end
