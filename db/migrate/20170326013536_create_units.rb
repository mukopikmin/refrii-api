# frozen_string_literal: true

class CreateUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :units do |t|
      t.string :label, null: false, unique: true
      t.float :step, null: false, default: 1.0

      t.references :user, null: false

      t.timestamps
    end
  end
end
