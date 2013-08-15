BusinessModelCanvas::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Allow concurrency when using puma server. 
  config.preload_frameworks = true 
  config.allow_concurrency = true 

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port:    587,
    user_name: "try.canvas@gmail.com",
    password: "Computer84$",
    authentication: "plain",
    enable_starttls_auto: true }

end
