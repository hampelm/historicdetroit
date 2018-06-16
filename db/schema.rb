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

ActiveRecord::Schema.define(version: 2018_06_16_140333) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "architects", force: :cascade do |t|
    t.string "name"
    t.string "byline"
    t.string "last_name_first"
    t.string "firm"
    t.text "description"
    t.string "birth"
    t.string "death"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "slug"
  end

  create_table "architects_buildings", id: false, force: :cascade do |t|
    t.integer "building_id", null: false
    t.integer "architect_id", null: false
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.string "also_known_as"
    t.string "byline"
    t.text "description"
    t.string "address"
    t.string "status"
    t.string "style"
    t.string "year_opened"
    t.string "year_closed"
    t.string "year_demolished"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "architect_id"
    t.text "description_formatted"
    t.text "slug"
  end

  create_table "buildings_galleries", id: false, force: :cascade do |t|
    t.integer "gallery_id", null: false
    t.integer "building_id", null: false
  end

  create_table "buildings_posts", id: false, force: :cascade do |t|
    t.integer "building_id", null: false
    t.integer "post_id", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "galleries", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "slug"
  end

  create_table "photos", force: :cascade do |t|
    t.string "title"
    t.text "caption"
    t.string "byline"
    t.integer "gallery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id"], name: "index_photos_on_gallery_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
