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

ActiveRecord::Schema.define(version: 20130912004225) do

  create_table "associations", force: true do |t|
    t.integer  "user_id"
    t.integer  "canvas_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "canvases", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "channels", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "collaborations", force: true do |t|
    t.integer  "user_id"
    t.integer  "collaborator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collaborations", ["collaborator_id"], name: "index_collaborations_on_collaborator_id", using: :btree
  add_index "collaborations", ["user_id", "collaborator_id"], name: "index_collaborations_on_user_id_and_collaborator_id", unique: true, using: :btree
  add_index "collaborations", ["user_id"], name: "index_collaborations_on_user_id", using: :btree

  create_table "cost_structures", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "customer_segments", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "feeds", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "canvas_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: true do |t|
    t.integer  "user_id"
    t.integer  "canvas_id"
    t.string   "email"
    t.string   "status",     default: "Invite Pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "key_activities", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "key_metrics", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "ownerships", force: true do |t|
    t.integer  "user_id"
    t.integer  "canvas_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ownerships", ["canvas_id"], name: "index_ownerships_on_canvas_id", using: :btree
  add_index "ownerships", ["user_id", "canvas_id"], name: "index_ownerships_on_user_id_and_canvas_id", unique: true, using: :btree
  add_index "ownerships", ["user_id"], name: "index_ownerships_on_user_id", using: :btree

  create_table "problems", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "revenue_streams", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "unfair_advantages", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "unique_value_propositions", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "canvas_id"
    t.text     "tag_color",  default: "#3ba1bf", null: false
  end

  create_table "unread_feeds", force: true do |t|
    t.integer  "user_id"
    t.integer  "count",      default: 0
    t.integer  "list",       default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
