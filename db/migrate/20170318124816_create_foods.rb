# frozen_string_literal: true

class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.text :notice
      t.float :amount
      t.date :expiration_date

      t.binary :image_file
      t.integer :image_size
      t.string :image_content_type

      t.references :box, null: false
      t.references :unit
      t.references :created_user
      t.references :updated_user

      t.timestamps
    end
  end
end
