# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_04_133304) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.integer "pincode", null: false
    t.bigint "theatre_id", null: false
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.index ["theatre_id"], name: "index_addresses_on_theatre_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "iso_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "quantity", default: 0, null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "show_id", null: false
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["show_id"], name: "index_line_items_on_show_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title", null: false
    t.date "release_date", null: false
    t.text "description", null: false
    t.integer "duration_in_mins", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "trgm_idx_movies_description", opclass: :gin_trgm_ops, using: :gin
    t.index ["title"], name: "index_movies_on_title", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "completed_at"
    t.datetime "cancelled_at"
    t.string "number", null: false
    t.boolean "auto_cancellation"
    t.integer "status", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "cancelled_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cancelled_by_user_id"], name: "index_orders_on_cancelled_by_user_id"
    t.index ["completed_at"], name: "index_orders_on_completed_at"
    t.index ["number"], name: "index_orders_on_number", unique: true
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "number", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "completed_at"
    t.integer "status", default: 0, null: false
    t.string "charge_id"
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_id"], name: "index_payments_on_charge_id"
    t.index ["completed_at"], name: "index_payments_on_completed_at"
    t.index ["number"], name: "index_payments_on_number", unique: true
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["status"], name: "index_payments_on_status"
  end

  create_table "refunds", force: :cascade do |t|
    t.string "number", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "completed_at"
    t.string "stripe_refund_id"
    t.integer "status", default: 0, null: false
    t.bigint "payment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed_at"], name: "index_refunds_on_completed_at"
    t.index ["number"], name: "index_refunds_on_number", unique: true
    t.index ["payment_id"], name: "index_refunds_on_payment_id"
    t.index ["status"], name: "index_refunds_on_status"
    t.index ["stripe_refund_id"], name: "index_refunds_on_stripe_refund_id"
  end

  create_table "shows", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.decimal "price", null: false
    t.integer "status", default: 0, null: false
    t.bigint "theatre_id", null: false
    t.bigint "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seats_available", default: 0, null: false
    t.index ["movie_id"], name: "index_shows_on_movie_id"
    t.index ["theatre_id"], name: "index_shows_on_theatre_id"
  end

  create_table "theatres", force: :cascade do |t|
    t.string "name", null: false
    t.integer "screen_type", null: false
    t.integer "seating_capacity", null: false
    t.boolean "operational", default: false, null: false
    t.string "contact_number", null: false
    t.string "contact_email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_theatres_on_name"
  end

  create_table "user_reactions", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "reactable_type", null: false
    t.bigint "reactable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reactable_type", "reactable_id"], name: "index_user_reactions_on_reactable"
    t.index ["status"], name: "index_user_reactions_on_status"
    t.index ["user_id"], name: "index_user_reactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "disabled", default: false
    t.integer "role", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "upcoming_movies_alert", default: true, null: false
    t.string "auth_token"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "countries"
  add_foreign_key "addresses", "theatres"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "shows"
  add_foreign_key "orders", "users"
  add_foreign_key "orders", "users", column: "cancelled_by_user_id"
  add_foreign_key "payments", "orders"
  add_foreign_key "refunds", "payments"
  add_foreign_key "shows", "movies"
  add_foreign_key "shows", "theatres"
  add_foreign_key "user_reactions", "users"
end
