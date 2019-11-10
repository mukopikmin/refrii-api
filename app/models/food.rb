# frozen_string_literal: true

class Food < ApplicationRecord
  has_paper_trail

  belongs_to :box
  belongs_to :unit
  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'
  has_many :notices
  has_many :shop_plans
  has_one_attached :image

  validates_presence_of :name
  validates_presence_of :box
  validates_presence_of :unit
  validates_presence_of :created_user
  validates_presence_of :updated_user
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :owned_by, ->(user) { joins(:box).where(boxes: { owner: user }) }
  scope :inviting, ->(user) { joins(box: :invitations).where(box: { invitations: { user: user } }) }

  def assignable_units
    box.owner.units
  end

  def accessible_for?(user)
    box.accessible_for?(user)
  end

  def self.all_with_invited(user)
    Box.all_with_invited(user).map(&:foods).flatten
  end

  def revert
    previous = paper_trail.previous_version
    params = {
      name: previous.name,
      amount: previous.amount,
      expiration_date: previous.expiration_date
    }

    !previous.nil? && update(params)
  end
end
