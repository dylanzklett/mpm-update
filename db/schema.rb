# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160613190705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "curtains", force: :cascade do |t|
    t.string   "building_number"
    t.string   "room"
    t.float    "width"
    t.float    "height"
    t.boolean  "inside"
    t.string   "wall_type"
    t.string   "fabric_color"
    t.string   "trough_color"
    t.integer  "center_support"
    t.integer  "end_bracket"
    t.integer  "quantity"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.decimal  "price",           precision: 10, scale: 3
    t.integer  "project_id"
    t.string   "metric",                                   default: "Imperial"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "email"
    t.integer  "sales_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customers", ["email"], name: "index_customers_on_email", using: :btree
  add_index "customers", ["sales_id"], name: "index_customers_on_sales_id", using: :btree

  create_table "inventory_history_items", force: :cascade do |t|
    t.integer  "inventory_item_id", null: false
    t.integer  "support_item_id"
    t.string   "event",             null: false
    t.string   "whodunnit"
    t.float    "amount"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer  "manufacturer_id"
    t.string   "name"
    t.string   "description"
    t.string   "unit"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "quantity"
    t.decimal  "price",       precision: 10, scale: 3
    t.integer  "project_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "auto_create",                          default: false
    t.string   "unit"
  end

  add_index "items", ["name"], name: "index_items_on_name", using: :btree

  create_table "manufacturers", force: :cascade do |t|
    t.string   "title"
    t.string   "email"
    t.string   "phone"
    t.text     "address"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "manufacturer_type"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "person_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "first_title"
    t.string   "second_title"
    t.string   "first_address"
    t.string   "second_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone_o"
    t.string   "phone_c"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "country",        default: "USA"
  end

  add_index "profiles", ["city"], name: "index_profiles_on_city", using: :btree
  add_index "profiles", ["first_address"], name: "index_profiles_on_first_address", using: :btree
  add_index "profiles", ["first_name"], name: "index_profiles_on_first_name", using: :btree
  add_index "profiles", ["last_name"], name: "index_profiles_on_last_name", using: :btree
  add_index "profiles", ["phone_c"], name: "index_profiles_on_phone_c", using: :btree
  add_index "profiles", ["phone_o"], name: "index_profiles_on_phone_o", using: :btree
  add_index "profiles", ["second_address"], name: "index_profiles_on_second_address", using: :btree
  add_index "profiles", ["state"], name: "index_profiles_on_state", using: :btree

  create_table "project_versions", force: :cascade do |t|
    t.integer  "project_id",     null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.text     "object_changes"
    t.datetime "created_at"
  end

  add_index "project_versions", ["project_id"], name: "index_project_versions_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "state"
    t.integer  "customer_id"
    t.decimal  "price",           precision: 10, scale: 3
    t.float    "discount"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.date     "start_at"
    t.string   "customer_number"
    t.string   "sales_number"
    t.integer  "sales_id"
    t.string   "description"
    t.string   "name"
    t.integer  "proposal_number"
  end

  add_index "projects", ["customer_id"], name: "index_projects_on_customer_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",           precision: 10, scale: 3
    t.integer  "manufacturer_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "code"
    t.text     "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "type"
  end

  create_table "support_items", force: :cascade do |t|
    t.integer  "task_id"
    t.string   "name"
    t.string   "unit"
    t.float    "quantity"
    t.decimal  "price",      precision: 10, scale: 3
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "support_items", ["name"], name: "index_support_items_on_name", using: :btree

  create_table "task_items", force: :cascade do |t|
    t.integer "task_id"
    t.integer "quantity"
    t.string  "trough_size"
    t.string  "trough_color"
    t.float   "width_per_curt"
    t.float   "finished_length"
    t.string  "pattern_color"
    t.string  "room"
    t.float   "width"
    t.float   "height"
    t.float   "calculated_fabric"
    t.float   "calculated_weight"
    t.float   "calculated_labor"
    t.float   "calculated_shirring"
    t.float   "calculated_tape"
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "status"
    t.integer  "manufacturer_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "ship_via"
    t.text     "ship_to"
    t.text     "instructions"
    t.string   "mitech_po"
    t.date     "date_wanted"
    t.date     "mitech_rec_date"
    t.string   "pref_ship_method"
    t.string   "customer_po"
    t.string   "type"
    t.integer  "project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
    t.string   "rep_number"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
