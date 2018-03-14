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

ActiveRecord::Schema.define(version: 20180313173505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "consignments", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "date_available"
    t.boolean  "need_pickup"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "address_1_pickup"
    t.string   "address_2_pickup"
    t.string   "city_pickup"
    t.string   "state_pickup"
    t.string   "zip_pickup"
    t.string   "address_1_mailing"
    t.string   "address_2_mailing"
    t.string   "city_mailing"
    t.string   "state_mailing"
    t.string   "zip_mailing"
    t.string   "home_phone"
    t.string   "consigner_number"
    t.decimal  "consignment_price"
    t.text     "contract"
    t.text     "contract_additional_item"
    t.integer  "status",                   default: 0
    t.boolean  "admin_created",            default: false
    t.boolean  "dashboard_modified",       default: false
    t.string   "price_range"
    t.string   "other_phone"
    t.string   "other_email"
    t.string   "other_contact"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer  "consignment_id"
    t.integer  "contract_type"
    t.text     "intro"
    t.text     "terms_and_conditions"
    t.text     "systematic_price_reductions"
    t.text     "optional_extension"
    t.text     "end_of_agreement"
    t.text     "note"
    t.text     "payment_to_consignor"
    t.text     "insurance"
    t.text     "additional_notes"
    t.text     "accepted_items",                  default: [],              array: true
    t.text     "rejected_items",                  default: [],              array: true
    t.datetime "experation_date"
    t.integer  "contract_status"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.text     "terms_and_conditions_list",       default: [],              array: true
    t.string   "generated_contract_file_name"
    t.string   "generated_contract_content_type"
    t.integer  "generated_contract_file_size"
    t.datetime "generated_contract_updated_at"
    t.string   "contract_url"
    t.index ["consignment_id"], name: "index_contracts_on_consignment_id", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.integer  "consignment_id"
    t.string   "image"
    t.text     "description"
    t.string   "type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "item_type"
    t.decimal  "value"
    t.decimal  "price"
    t.decimal  "cost"
    t.integer  "item_status",    default: 0
    t.decimal  "item_price"
    t.string   "item_number"
    t.string   "price_range"
    t.index ["consignment_id"], name: "index_items_on_consignment_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "contract_type"
    t.text     "intro"
    t.text     "terms_and_conditions"
    t.text     "systematic_price_reductions"
    t.text     "optional_extension"
    t.text     "end_of_agreement"
    t.text     "note"
    t.text     "payment_to_consignor"
    t.text     "insurance"
    t.text     "additional_notes"
    t.datetime "experation_date"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "terms_and_conditions_list",   default: [],              array: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "deleted_at"
    t.boolean  "support",                default: false, null: false
    t.string   "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.string   "time_zone"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
