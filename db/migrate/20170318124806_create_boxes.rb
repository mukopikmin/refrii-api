class CreateBoxes < ActiveRecord::Migration[5.0]
  def change
    create_table :boxes do |t|
      t.string :name
      t.text :notice

      t.references :owner

      t.timestamps
    end
  end
end
