class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string :label, null: false, unique: true

      t.references :user, null: false

      t.timestamps
    end
  end
end
