class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.text :notice
      t.float :amount
      t.date :expiration_date
      t.boolean :removed, null: false, default: false

      t.references :box, null: false
      t.references :unit

      t.timestamps
    end
  end
end
