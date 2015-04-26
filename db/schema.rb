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

ActiveRecord::Schema.define(version: 20150426224414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "domain_terms", force: :cascade do |t|
    t.integer "domain_id"
    t.integer "term_id"
    t.integer "tf"
    t.integer "df"
  end

  create_table "domains", force: :cascade do |t|
    t.string   "name"
    t.string   "eval_type"
    t.integer  "domain_id"
    t.integer  "alter_id"
    t.integer  "eval_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "domains", ["domain_id"], name: "index_domains_on_domain_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "labels", force: :cascade do |t|
    t.integer  "eval_id"
    t.integer  "www_id"
    t.integer  "nowww_id"
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

  create_table "terms", force: :cascade do |t|
    t.integer  "eval_id"
    t.string   "text"
    t.integer  "tf"
    t.integer  "df"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "domains", "domains"
  add_foreign_key "identities", "users"
end
