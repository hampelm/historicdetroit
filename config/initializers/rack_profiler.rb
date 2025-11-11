# frozen_string_literal: true

if Rails.env.development? || Rails.env.production?
  require "rack-mini-profiler"

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)

  if Rails.env.production?
    # Only authorize admin users in production
    Rack::MiniProfiler.config.pre_authorize_cb = lambda { |env|
      warden = env['warden']
      
      # Check if user is logged in and is an admin
      warden&.user&.admin == true
    }
  end
end
