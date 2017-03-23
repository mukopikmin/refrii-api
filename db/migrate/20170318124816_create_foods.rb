class CreateFoods < ActiveRecord::Migration[5.0]
  def change
    create_table :foods do |t|
      t.string :name
      t.text :notice
      t.float :amount
      t.date :expiration_date

      t.references :room

      t.timestamps
    end
  end
end
