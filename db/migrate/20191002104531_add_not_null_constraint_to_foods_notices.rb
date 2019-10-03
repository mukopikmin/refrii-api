# frozen_string_literal: true

class AddNotNullConstraintToFoodsNotices < ActiveRecord::Migration[5.2]
  def change
    change_column :foods, :amount, :float, null: false, default: 0.0
    change_column :foods, :unit_id, :integer, null: false
    change_column :foods, :created_user_id, :integer, null: false
    change_column :foods, :updated_user_id, :integer, null: false
    change_column :notices, :food_id, :integer, null: false
    change_column :notices, :created_user_id, :integer, null: false
  end
end
