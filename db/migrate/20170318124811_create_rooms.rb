class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :notice

      t.references :box

      t.timestamps
    end
  end
end
