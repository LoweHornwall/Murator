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

ActiveRecord::Schema.define(version: 20180511124353) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categories_curation_pages", id: false, force: :cascade do |t|
    t.integer "curation_page_id", null: false
    t.integer "category_id", null: false
    t.index ["curation_page_id", "category_id"], name: "curation_page_category_id", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.string "content"
    t.integer "review_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_comments_on_review_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "curation_pages", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "page_followings_count"
    t.integer "reviews_count", default: 0
    t.integer "view_count", default: 0
    t.index ["name"], name: "index_curation_pages_on_name", unique: true
    t.index ["user_id"], name: "index_curation_pages_on_user_id"
  end

  create_table "page_followings", force: :cascade do |t|
    t.integer "user_id"
    t.integer "curation_page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["curation_page_id"], name: "index_page_followings_on_curation_page_id"
    t.index ["user_id", "curation_page_id"], name: "index_page_followings_on_user_id_and_curation_page_id", unique: true
    t.index ["user_id"], name: "index_page_followings_on_user_id"
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
    t.integer "page_followings_count"
    t.integer "curation_pages_count", default: 0
    t.string "remember_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
