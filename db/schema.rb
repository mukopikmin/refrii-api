# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170403112643) do

  create_table "boxes", force: :cascade do |t|
    t.string "name", null: false
    t.text "notice"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_boxes_on_user_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name", null: false
    t.text "notice"
    t.float "amount"
    t.date "expiration_date"
    t.integer "box_id", null: false
    t.integer "unit_id"
    t.integer "created_user_id"
    t.integer "updated_user_id"
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
    t.string "password_digest"
    t.boolean "disabled", default: false, null: false
    t.boolean "admin", default: false, null: false
    t.string "provider", default: "local"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
