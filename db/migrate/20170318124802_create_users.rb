class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest
      t.boolean :disabled, null: false, default: false
      t.boolean :admin, null: false, default: false
      t.string :provider, null: false, default: 'local'

      # t.integer :avatar_size
      # t.string :avatar_content_type
      # t.binary :avatar_file

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
