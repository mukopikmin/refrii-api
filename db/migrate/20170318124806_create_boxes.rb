class CreateBoxes < ActiveRecord::Migration[5.0]
  def change
    create_table :boxes do |t|
      t.string :name, null: false
      t.text :notice

      t.binary :image_file
      t.integer :image_size
      t.string :image_content_type

      t.references :user, null: false

      t.timestamps
    end
  end
end
