Rails.application.configure do

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  # ExceptionHandler replaces Rails' default error pages with dynamic views.
  config.consider_all_requests_local = false
  config.exception_handler = { dev: true }

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :mem_cache_store

    # Configure Rack::Cache (rack middleware, whole page / static assets) (we set
    # value_max_bytes to 10MB, most memcache servers won't allow values larger
    # than 1MB but this stops Rack::Cache returning a 5xx error. With this
    # option, Rack::Cache just returns a miss).
    client = Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "memcached").split(","),
                                failover: true,
                                socket_timeout: 1.5,
                                socket_failure_delay: 0.2,
                                down_retry_delay: 60,
                                pool_size: ENV.fetch("WEB_CONCURRENCY") { 5 },
                                value_max_bytes: 10485760)
    config.action_dispatch.rack_cache = {
      metastore:    client,
      entitystore:  client
    }
    config.static_cache_control = "public, max-age=#{2.days.to_i}"
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener_web
  host = 'localhost:3000' # Don't use this literally; use your local dev host instead
  config.action_mailer.default_url_options = {host: host, protocol: 'http'} # use https in production

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # watch your queries while you develop your application and notify you
  # when you should add eager loading (N+1 queries),
  # when you use eager loading that is not necessary - and
  # when you should use counter caching
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    # Bullet.growl = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end

  config.web_console.whitelisted_ips = '172.19.0.1'
end

# BetterErrors in Docker container
BetterErrors::Middleware.allow_ip! "0.0.0.0/0"





