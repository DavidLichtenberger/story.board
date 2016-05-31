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

ActiveRecord::Schema.define(version: 20160524231702) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conditions", force: :cascade do |t|
    t.integer  "from"
    t.integer  "to"
    t.integer  "text_component_id"
    t.integer  "sensor_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "conditions", ["sensor_id"], name: "index_conditions_on_sensor_id", using: :btree
  add_index "conditions", ["text_component_id"], name: "index_conditions_on_text_component_id", using: :btree

  create_table "sensor_readings", force: :cascade do |t|
    t.integer  "calibrated_value"
    t.integer  "uncalibrated_value"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "sensor_id"
  end

  add_index "sensor_readings", ["sensor_id"], name: "index_sensor_readings_on_sensor_id", using: :btree

  create_table "sensor_types", force: :cascade do |t|
    t.string   "property"
    t.string   "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensors", force: :cascade do |t|
    t.string   "name"
    t.integer  "address"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "sensor_type_id"
  end

  add_index "sensors", ["name"], name: "index_sensors_on_name", unique: true, using: :btree
  add_index "sensors", ["sensor_type_id"], name: "index_sensors_on_sensor_type_id", using: :btree

  create_table "text_components", force: :cascade do |t|
    t.string   "heading"
    t.text     "introduction"
    t.text     "main_part"
    t.text     "closing"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "conditions", "sensors"
  add_foreign_key "conditions", "text_components"
end
