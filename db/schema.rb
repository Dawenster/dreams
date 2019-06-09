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

ActiveRecord::Schema.define(version: 2019_05_25_061141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gist"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount_in_cents", null: false
    t.integer "fee_in_cents", null: false
    t.string "stripe_charge_id", null: false
    t.string "currency", null: false
    t.uuid "user_id", null: false
    t.uuid "payment_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_method_id"], name: "index_charges_on_payment_method_id"
    t.index ["user_id"], name: "index_charges_on_user_id"
  end

  create_table "dreams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", null: false
    t.boolean "published", default: false
    t.index ["user_id"], name: "index_dreams_on_user_id"
  end

  create_table "dreams_elements", force: :cascade do |t|
    t.uuid "dream_id", null: false
    t.uuid "element_id", null: false
    t.index ["dream_id"], name: "index_dreams_elements_on_dream_id"
    t.index ["element_id"], name: "index_dreams_elements_on_element_id"
  end

  create_table "elements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "dimension", null: false
    t.text "commentary", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_methods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "payment_method_type", null: false
    t.string "stripe_payment_method_id", null: false
    t.string "brand", null: false
    t.string "funding", null: false
    t.string "last4", null: false
    t.string "exp_month", null: false
    t.string "exp_year", null: false
    t.string "status", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payment_methods_on_user_id"
  end

  create_table "purchases", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "message"
    t.uuid "recipient_id", null: false
    t.uuid "buyer_id", null: false
    t.uuid "dream_id", null: false
    t.uuid "charge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_purchases_on_buyer_id"
    t.index ["charge_id"], name: "index_purchases_on_charge_id"
    t.index ["dream_id"], name: "index_purchases_on_dream_id"
    t.index ["recipient_id"], name: "index_purchases_on_recipient_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "charges", "payment_methods"
  add_foreign_key "charges", "users"
  add_foreign_key "dreams", "users"
  add_foreign_key "dreams_elements", "dreams"
  add_foreign_key "dreams_elements", "elements"
  add_foreign_key "payment_methods", "users"
  add_foreign_key "purchases", "charges"
  add_foreign_key "purchases", "dreams"
  add_foreign_key "purchases", "users", column: "buyer_id"
  add_foreign_key "purchases", "users", column: "recipient_id"
end
