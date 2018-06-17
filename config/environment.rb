# Load the Rails application.
require_relative 'application'

# Set common configuration for all environments
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Set Available and defualt locals
  config.i18n.available_locales = [:en, :ar]
  config.i18n.default_locale = :en
end

# Initialize the Rails application.
Rails.application.initialize!
