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

ActiveRecord::Schema.define(version: 2018_10_18_221048) do

  create_table "students", id: :string, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "nutrition"
    t.string "subject"
    t.text "comment"
    t.string "councillor"
    t.integer "registration_number"
    t.boolean "has_payed", default: false
    t.boolean "is_booked"
    t.boolean "is_canceled", default: false
    t.date "date_of_birth"
    t.integer "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: false
    t.boolean "is_on_waiting_list", default: false
    t.integer "number_on_waiting_list", default: 0
    t.index ["id"], name: "sqlite_autoindex_students_1", unique: true
    t.index ["trip_id"], name: "index_students_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "title"
    t.decimal "fee", precision: 5, scale: 2
    t.datetime "departure_at"
    t.integer "max_students", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "ident"
    t.string "token"
    t.datetime "token_expires_at"
    t.index ["ident"], name: "index_users_on_ident"
    t.index ["token"], name: "index_users_on_token", unique: true
  end

end
