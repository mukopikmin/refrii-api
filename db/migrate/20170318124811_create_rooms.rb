class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.text :notice
      t.boolean :removed, null: false, default: false

      t.references :box, null: false

      t.timestamps
    end
  end
end
