# Settings specified here will take precedence over those in config/environment.rb

config.after_initialize do
  EnginesHelper.autoload_assets = false
end

# =============================================================================
require "#{RAILS_ROOT}/lib/message_logger.rb"
logger = MessageLogger.new(RAILS_ENV, File.join( 'log/', RAILS_ENV + ".log"))
ActiveRecord::Base.logger = logger
ActionController::Base.logger = logger
# =============================================================================

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
#config.action_controller.perform_caching             = true
#config.action_view.cache_template_loading            = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = false


# DEBUG
# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# DEBUG
# See everything in the log (default is :info)
# config.log_level = :warn
config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

ActionMailer::Base.delivery_method = :sendmail

# ST-specific configuration entries
config.notifications.donors        = true
config.notifications.savers        = false
config.notifications.organizations = false
