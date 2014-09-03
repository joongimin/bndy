require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bndy
  class Application < Rails::Application
    config.time_zone = 'Seoul'
    config.action_mailer.delivery_method = :amazon_ses
    config.action_controller.action_on_unpermitted_parameters = :raise

    config.generators do |g|
      g.jbuilder false
      g.assets false
      g.helper false
      g.test_framework false
      g.orm :active_record
    end
  end
end
