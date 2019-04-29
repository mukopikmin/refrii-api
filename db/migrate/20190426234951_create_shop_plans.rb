# frozen_string_literal: true

class CreateShopPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_plans do |t|
      t.string :notice
      t.boolean :done, null: false, default: false
      t.date :date, null: false
      t.float :amount, null: false

      t.references :food, foreign_key: true, null: false

      t.timestamps
    end
  end
end
