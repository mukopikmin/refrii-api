# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_22_143018) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "boxes", force: :cascade do |t|
    t.string "name", null: false
    t.text "notice"
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_boxes_on_owner_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name", null: false
    t.float "amount", default: 0.0, null: false
    t.date "expiration_date"
    t.integer "box_id", null: false
    t.integer "unit_id", null: false
    t.integer "created_user_id", null: false
    t.bigint "updated_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["box_id"], name: "index_foods_on_box_id"
    t.index ["created_user_id"], name: "index_foods_on_created_user_id"
    t.index ["unit_id"], name: "index_foods_on_unit_id"
    t.index ["updated_user_id"], name: "index_foods_on_updated_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "box_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["box_id"], name: "index_invitations_on_box_id"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "notices", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "food_id", null: false
    t.integer "created_user_id", null: false
    t.integer "updated_user_id", null: false
    t.index ["created_user_id"], name: "index_notices_on_created_user_id"
    t.index ["food_id"], name: "index_notices_on_food_id"
    t.index ["updated_user_id"], name: "index_notices_on_updated_user_id"
  end

  create_table "push_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_push_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_push_tokens_on_user_id"
  end

  create_table "shop_plans", force: :cascade do |t|
    t.string "notice"
    t.boolean "done", default: false, null: false
    t.date "date", null: false
    t.float "amount", null: false
    t.integer "food_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_shop_plans_on_food_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "label", null: false
    t.float "step", default: 1.0, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_units_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "disabled", default: false, null: false
    t.boolean "admin", default: false, null: false
    t.string "provider", default: "local", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.text "object_changes", limit: 1073741823
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "boxes", "users", column: "owner_id"
  add_foreign_key "foods", "boxes"
  add_foreign_key "foods", "units"
  add_foreign_key "invitations", "boxes"
  add_foreign_key "invitations", "users"
  add_foreign_key "notices", "foods"
  add_foreign_key "notices", "users", column: "created_user_id"
  add_foreign_key "notices", "users", column: "updated_user_id"
  add_foreign_key "push_tokens", "users"
  add_foreign_key "shop_plans", "foods"
  add_foreign_key "units", "users"
end
