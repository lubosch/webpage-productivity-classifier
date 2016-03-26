# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160325194430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_type_terms", force: :cascade do |t|
    t.integer  "activity_type_id"
    t.integer  "term_id"
    t.integer  "tf"
    t.float    "probability"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.float    "multinomial_probability"
    t.string   "term_type"
  end

  add_index "activity_type_terms", ["activity_type_id"], name: "index_activity_type_terms_on_activity_type_id", using: :btree
  add_index "activity_type_terms", ["term_id"], name: "index_activity_type_terms_on_term_id", using: :btree

  create_table "activity_types", force: :cascade do |t|
    t.text     "name"
    t.integer  "count"
    t.float    "probability"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "vocabulary_size"
    t.integer  "terms_count"
    t.float    "default_multinomial"
  end

  create_table "application_activity_types", force: :cascade do |t|
    t.integer  "activity_type_id"
    t.integer  "application_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "based_on"
    t.integer  "application_page_id"
    t.integer  "is_work"
    t.integer  "user_id"
  end

  add_index "application_activity_types", ["activity_type_id"], name: "index_application_activity_types_on_activity_type_id", using: :btree
  add_index "application_activity_types", ["application_id"], name: "index_application_activity_types_on_application_id", using: :btree

  create_table "application_clusters", force: :cascade do |t|
    t.integer  "application_id"
    t.string   "application_type"
    t.integer  "cluster_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "application_clusters", ["application_id", "application_type"], name: "application_clusters_polymoprh_application_index", using: :btree

  create_table "application_pages", force: :cascade do |t|
    t.integer  "application_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "url"
    t.integer  "static"
    t.integer  "user_static"
  end

  add_index "application_pages", ["application_id"], name: "index_application_pages_on_application_id", using: :btree

  create_table "application_terms", force: :cascade do |t|
    t.integer "application_page_id"
    t.integer "term_id"
    t.integer "tf"
    t.string  "term_type"
  end

  add_index "application_terms", ["application_page_id"], name: "index_application_terms_on_application_page_id", using: :btree

  create_table "applications", force: :cascade do |t|
    t.string   "name"
    t.string   "eval_type"
    t.string   "lang"
    t.integer  "eval_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "url"
    t.integer  "static"
    t.integer  "user_static"
  end

  add_index "applications", ["eval_id"], name: "index_applications_on_eval_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "implicit_work_logs", force: :cascade do |t|
    t.string   "ip"
    t.integer  "in_work"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "labels", force: :cascade do |t|
    t.integer  "eval_id"
    t.integer  "application_id"
    t.integer  "assessor_id"
    t.integer  "adult"
    t.integer  "spam"
    t.integer  "news_editorial"
    t.integer  "commercial"
    t.integer  "educational_research"
    t.integer  "discussion"
    t.integer  "personal_leisure"
    t.integer  "media"
    t.integer  "database"
    t.integer  "readability_vis"
    t.integer  "readability_lang"
    t.integer  "neutrality"
    t.integer  "bias"
    t.integer  "trustiness"
    t.integer  "confidence"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "labels", ["application_id"], name: "index_labels_on_application_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "terms", force: :cascade do |t|
    t.integer  "eval_id"
    t.string   "text"
    t.integer  "ttf"
    t.integer  "df"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.decimal  "probability"
  end

  create_table "user_application_pages", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "application_page_id"
    t.integer  "user_id"
    t.float    "length"
    t.integer  "scroll_count"
    t.integer  "scroll_diff"
    t.integer  "tab_id"
    t.integer  "app_type"
    t.integer  "scroll_up"
    t.integer  "scroll_down"
    t.integer  "key_pressed"
    t.float    "key_pressed_rate"
    t.float    "scroll_rate"
    t.string   "ip"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lname"
    t.string   "fname"
    t.string   "username"
    t.integer  "desktop_logger"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "activity_type_terms", "activity_types"
  add_foreign_key "activity_type_terms", "terms"
  add_foreign_key "application_activity_types", "activity_types"
  add_foreign_key "application_activity_types", "applications"
  add_foreign_key "application_pages", "applications"
  add_foreign_key "identities", "users"
end
