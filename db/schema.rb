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

ActiveRecord::Schema.define(version: 20171023164653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author_first"
    t.string "author_last"
  end

  create_table "checkouts", force: :cascade do |t|
    t.integer "patron_id"
    t.integer "book_id"
    t.date "checkout_date"
    t.date "due_date"
    t.boolean "checked_in"
  end

  create_table "patrons", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
  end

  create_table "users", force: :cascade do |t|
    t.integer "patron_id"
    t.string "email"
    t.string "username"
    t.string "password"
    t.boolean "admin"
  end

end
