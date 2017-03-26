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

ActiveRecord::Schema.define(version: 20170326013536) do

  create_table "boxes", force: :cascade do |t|
    t.string   "name",                       null: false
    t.text     "notice"
    t.boolean  "removed",    default: false, null: false
    t.integer  "owner_id",                   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["owner_id"], name: "index_boxes_on_owner_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string   "name",                            null: false
    t.text     "notice"
    t.float    "amount"
    t.date     "expiration_date"
    t.boolean  "removed",         default: false, null: false
    t.integer  "room_id",                         null: false
    t.integer  "unit_id",                         null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["room_id"], name: "index_foods_on_room_id"
    t.index ["unit_id"], name: "index_foods_on_unit_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name",                       null: false
    t.text     "notice"
    t.boolean  "removed",    default: false, null: false
    t.integer  "box_id",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["box_id"], name: "index_rooms_on_box_id"
  end

  create_table "units", force: :cascade do |t|
    t.string   "label",                      null: false
    t.boolean  "removed",    default: false, null: false
    t.integer  "user_id",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_units_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "email",                           null: false
    t.string   "password_digest",                 null: false
    t.boolean  "admin",           default: false, null: false
    t.boolean  "removed",         default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

end
