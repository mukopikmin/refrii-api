# frozen_string_literal: true

class Notice < ApplicationRecord
  belongs_to :food
  belongs_to :created_user, class_name: 'User'
  belongs_to :updated_user, class_name: 'User'

  validates_presence_of :text
  validates_presence_of :food
  validates_presence_of :created_user
  validates_presence_of :updated_user
end
