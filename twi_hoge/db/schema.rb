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

ActiveRecord::Schema.define(version: 20140505080135) do

  create_table "models", force: true do |t|
    t.string   "userid"
    t.string   "tweetid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twi_models", force: true do |t|
    t.string   "uid"
    t.string   "tweetid"
    t.string   "time"
    t.string   "re_uid"
    t.string   "image"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ret_nickname"
    t.string   "rt_id"
  end

  add_index "twi_models", ["tweetid"], name: "index_twi_models_on_tweetid"
  add_index "twi_models", ["uid"], name: "index_twi_models_on_uid"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "screen_name"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
