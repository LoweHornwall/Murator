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

ActiveRecord::Schema.define(version: 20180328141820) do

  create_table "curation_pages", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_curation_pages_on_name", unique: true
    t.index ["user_id"], name: "index_curation_pages_on_user_id"
  end

  create_table "release_groups", force: :cascade do |t|
    t.string "rgid"
    t.string "release"
    t.string "artist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist"], name: "index_release_groups_on_artist"
    t.index ["release"], name: "index_release_groups_on_release"
    t.index ["rgid"], name: "index_release_groups_on_rgid", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.integer "rating", default: 10
    t.integer "curation_page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "release_group_id"
    t.index ["curation_page_id", "release_group_id"], name: "index_reviews_on_curation_page_id_and_release_group_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
