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

ActiveRecord::Schema[8.1].define(version: 2026_07_13_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "awards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.boolean "published", default: true, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  create_table "case_studies", force: :cascade do |t|
    t.text "context"
    t.datetime "created_at", null: false
    t.string "key_metric"
    t.integer "position", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.string "role"
    t.string "slug", null: false
    t.string "subtitle"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_case_studies_on_position"
    t.index ["published"], name: "index_case_studies_on_published"
    t.index ["slug"], name: "index_case_studies_on_slug", unique: true
  end

  create_table "case_study_sections", force: :cascade do |t|
    t.bigint "case_study_id", null: false
    t.datetime "created_at", null: false
    t.string "heading"
    t.integer "position", default: 0, null: false
    t.string "section_type", null: false
    t.datetime "updated_at", null: false
    t.index ["case_study_id", "position"], name: "index_case_study_sections_on_case_study_id_and_position"
    t.index ["case_study_id", "section_type"], name: "index_case_study_sections_on_case_study_id_and_section_type"
    t.index ["case_study_id"], name: "index_case_study_sections_on_case_study_id"
  end

  create_table "contact_messages", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_contact_messages_on_created_at"
  end

  create_table "visual_works", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.string "title", null: false
    t.string "tools"
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_visual_works_on_category"
    t.index ["position"], name: "index_visual_works_on_position"
    t.index ["published"], name: "index_visual_works_on_published"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "case_study_sections", "case_studies"
end
