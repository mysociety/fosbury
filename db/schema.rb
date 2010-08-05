# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100805155715) do

  create_table "applications", :force => true do |t|
    t.string   "name"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "task_parameter_types", :force => true do |t|
    t.string   "name"
    t.boolean  "required"
    t.text     "description"
    t.integer  "task_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_types", :force => true do |t|
    t.string   "name"
    t.string   "cached_slug"
    t.string   "start_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "provider_id"
    t.text     "description"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "task_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "callback_url"
    t.text     "callback_params"
    t.integer  "status_code",     :default => 0
    t.text     "return_url"
    t.integer  "setter_id"
    t.text     "params"
    t.text     "task_data"
  end

end
