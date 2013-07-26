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

ActiveRecord::Schema.define(version: 20130708121250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "uuid-ossp"

  create_table "api_keys", id: false, force: true do |t|
    t.uuid     "id",           null: false
    t.string   "access_token"
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["access_token"], :name => "index_api_keys_on_access_token", :unique => true
  add_index "api_keys", ["user_id"], :name => "index_api_keys_on_user_id"

  create_table "arenas", id: false, force: true do |t|
    t.uuid     "id",                                                  null: false
    t.string   "name"
    t.string   "foursquare_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "location",      limit: {:srid=>3785, :type=>"point"}
  end

  add_index "arenas", ["foursquare_id"], :name => "index_arenas_on_foursquare_id", :unique => true
  add_index "arenas", ["location"], :name => "index_arenas_on_location", :spatial => true

  create_table "buddyships", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.uuid     "user_id"
    t.uuid     "buddy_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buddyships", ["buddy_id"], :name => "index_buddyships_on_buddy_id"
  add_index "buddyships", ["user_id"], :name => "index_buddyships_on_user_id"

  create_table "games", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["name"], :name => "index_games_on_name", :unique => true

  create_table "participations", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.uuid     "team_id"
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["team_id"], :name => "index_participations_on_team_id"
  add_index "participations", ["user_id"], :name => "index_participations_on_user_id"

  create_table "rounds", id: false, force: true do |t|
    t.uuid     "id",         null: false
    t.string   "state"
    t.uuid     "game_id"
    t.uuid     "arena_id"
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rounds", ["arena_id"], :name => "index_rounds_on_arena_id"
  add_index "rounds", ["game_id"], :name => "index_rounds_on_game_id"
  add_index "rounds", ["user_id"], :name => "index_rounds_on_user_id"

  create_table "teams", id: false, force: true do |t|
    t.uuid     "id",                         null: false
    t.string   "name"
    t.boolean  "winner",     default: false
    t.uuid     "round_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["round_id"], :name => "index_teams_on_round_id"

  create_table "users", id: false, force: true do |t|
    t.uuid     "id",          null: false
    t.string   "name"
    t.string   "email"
    t.string   "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id", :unique => true

end
