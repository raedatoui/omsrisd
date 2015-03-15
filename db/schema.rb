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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150315052115) do

  create_table "oms_custom_field_definitions", :force => true do |t|
    t.integer  "node_type_id"
    t.string   "token"
    t.text     "validations"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "name"
    t.string   "data_type",    :default => "text"
    t.string   "type"
  end

  add_index "oms_custom_field_definitions", ["node_type_id"], :name => "index_oms_custom_field_definitions_on_node_type_id"

  create_table "oms_custom_fields", :force => true do |t|
    t.integer  "node_id"
    t.integer  "custom_field_definition_id"
    t.text     "value"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.text     "file_data"
  end

  add_index "oms_custom_fields", ["custom_field_definition_id"], :name => "index_oms_custom_fields_on_custom_field_definition_id"
  add_index "oms_custom_fields", ["node_id"], :name => "index_oms_custom_fields_on_node_id"

  create_table "oms_followings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "node_id"
    t.integer  "initiator_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "oms_followings", ["initiator_id"], :name => "index_oms_followings_on_initiator_id"
  add_index "oms_followings", ["node_id", "user_id"], :name => "index_oms_followings_on_node_id_and_user_id", :unique => true

  create_table "oms_node_types", :force => true do |t|
    t.string   "name"
    t.string   "token"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "promotable", :default => false
    t.string   "color"
    t.boolean  "media",      :default => false
    t.integer  "weight",     :default => 1
  end

  create_table "oms_nodes", :force => true do |t|
    t.string   "name"
    t.text     "page"
    t.integer  "node_type_id"
    t.string   "file"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.text     "html"
    t.string   "published_state",    :default => "draft", :null => false
    t.datetime "published_at"
    t.integer  "publisher_id"
    t.text     "public_attributes"
    t.boolean  "attributes_changed"
    t.text     "file_data"
    t.text     "text"
    t.string   "slug"
  end

  add_index "oms_nodes", ["node_type_id"], :name => "index_oms_nodes_on_node_type_id"

  create_table "oms_promotions", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "node_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "automatic",  :default => false
    t.integer  "priority"
  end

  add_index "oms_promotions", ["node_id"], :name => "index_oms_promotions_on_node_id"

  create_table "oms_relationships", :force => true do |t|
    t.integer  "node_id"
    t.integer  "related_id"
    t.boolean  "embedded"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "weight"
  end

  add_index "oms_relationships", ["node_id", "related_id"], :name => "index_oms_relationships_on_node_id_and_related_id", :unique => true

  create_table "oms_taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "oms_taggings", ["tag_id"], :name => "index_oms_taggings_on_tag_id"
  add_index "oms_taggings", ["taggable_id", "taggable_type", "context"], :name => "index_oms_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "oms_tags", :force => true do |t|
    t.string "name"
    t.string "color", :null => false
  end

  create_table "oms_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name",                                   :null => false
  end

  add_index "oms_users", ["email"], :name => "index_oms_users_on_email", :unique => true
  add_index "oms_users", ["reset_password_token"], :name => "index_oms_users_on_reset_password_token", :unique => true

  create_table "oms_versions", :force => true do |t|
    t.string   "item_type",               :null => false
    t.integer  "item_id",                 :null => false
    t.string   "event",                   :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.text     "changed_attribute_names"
  end

  add_index "oms_versions", ["item_type", "item_id"], :name => "index_oms_versions_on_item_type_and_item_id"

end
