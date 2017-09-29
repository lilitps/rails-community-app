# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_170_912_104_501) do
  create_table 'posts', force: :cascade do |t|
    t.text 'content'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'picture'
    t.index %w[user_id created_at], name: 'index_posts_on_user_id_and_created_at'
    t.index ['user_id'], name: 'index_posts_on_user_id'
  end

  create_table 'relationships', force: :cascade do |t|
    t.integer 'follower_id'
    t.integer 'followed_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['followed_id'], name: 'index_relationships_on_followed_id'
    t.index %w[follower_id followed_id], name: 'index_relationships_on_follower_id_and_followed_id', unique: true
    t.index ['follower_id'], name: 'index_relationships_on_follower_id'
  end

  create_table 'user_sessions', force: :cascade do |t|
    t.string 'session_id', null: false
    t.text 'data'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['session_id'], name: 'index_user_sessions_on_session_id'
    t.index ['updated_at'], name: 'index_user_sessions_on_updated_at'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'crypted_password'
    t.string 'persistence_token'
    t.boolean 'admin', default: false
    t.datetime 'activated_at'
    t.string 'locale', default: 'en'
    t.string 'password_salt'
    t.string 'perishable_token'
    t.integer 'login_count', default: 0, null: false
    t.integer 'failed_login_count', default: 0, null: false
    t.datetime 'last_request_at'
    t.datetime 'current_login_at'
    t.datetime 'last_login_at'
    t.string 'current_login_ip'
    t.string 'last_login_ip'
    t.boolean 'active', default: false
    t.boolean 'approved', default: false
    t.boolean 'confirmed', default: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['last_request_at'], name: 'index_users_on_last_request_at'
    t.index ['perishable_token'], name: 'index_users_on_perishable_token', unique: true
    t.index ['persistence_token'], name: 'index_users_on_persistence_token', unique: true
  end
end
