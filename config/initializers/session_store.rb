# frozen_string_literal: true

# Be sure to restart your server when you modify this file.
require "active_support/cache/dalli_store"

Rails.application.config.session_store ActionDispatch::Session::CacheStore,
  cache: ActiveSupport::Cache::DalliStore.new((ENV["MEMCACHIER_SERVERS"] || "memcached").split(","),
    username: ENV["MEMCACHIER_USERNAME"],
    password: ENV["MEMCACHIER_PASSWORD"],
    pool_size: ENV.fetch("WEB_CONCURRENCY") { 5 },
    key: "_community_app_session")
