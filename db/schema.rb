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

ActiveRecord::Schema.define(version: 2020_04_19_213043) do

  create_table "point_of_sales", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "trading_name", null: false
    t.string "owner_name", null: false
    t.string "document", null: false
    t.geometry "coverage_area", limit: {:type=>"multi_polygon", :srid=>0}, null: false
    t.geometry "address", limit: {:type=>"point", :srid=>0}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coverage_area"], name: "index_point_of_sales_on_coverage_area", type: :spatial
    t.index ["document"], name: "index_point_of_sales_on_document", unique: true
  end

end
