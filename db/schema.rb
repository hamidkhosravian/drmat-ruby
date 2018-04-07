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

ActiveRecord::Schema.define(version: 20180407121524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_tokens", force: :cascade do |t|
    t.string "token"
    t.string "refresh_token"
    t.string "socket_token"
    t.datetime "token_expires_at"
    t.string "refresh_token_expires_at"
    t.datetime "socket_token_expires_at"
    t.bigint "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_auth_tokens_on_device_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.integer "os"
    t.integer "agent"
    t.inet "device_last_ip"
    t.inet "device_current_ip"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verify"
    t.datetime "verify_sent_at"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "phone"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
  end

  add_foreign_key "auth_tokens", "devices"
  add_foreign_key "devices", "users"
end
