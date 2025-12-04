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

ActiveRecord::Schema[7.1].define(version: 2025_12_04_184253) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "content_tags", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category"
    t.index ["content_id"], name: "index_content_tags_on_content_id"
    t.index ["tag_id"], name: "index_content_tags_on_tag_id"
  end

  create_table "contents", force: :cascade do |t|
    t.integer "format"
    t.string "title"
    t.string "date_of_release"
    t.string "creator"
    t.text "description"
    t.integer "duration"
    t.string "image_url"
    t.float "popularity_score"
    t.datetime "is_processed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "provider_records", force: :cascade do |t|
    t.string "provider_name"
    t.string "provider_content_id"
    t.bigint "content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_provider_records_on_content_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "content_tags", "contents"
  add_foreign_key "content_tags", "tags"
  add_foreign_key "provider_records", "contents"
end
