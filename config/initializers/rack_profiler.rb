# frozen_string_literal: true

if Rails.env.development? || Rails.env.production?
  require "rack-mini-profiler"

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
  
  if Rails.env.production?
    Rack::MiniProfiler.config.tap do |c|
      # Enable authorization for production
      # WARNING: :allow_all makes profiler visible to everyone
      # Consider using IP whitelist or custom authorization for security
      # c.authorization_mode = :allow_all
      
      # Alternative: Use IP-based authorization (uncomment and add your IP)
      c.authorization_mode = :allowlist
      c.ip_whitelist = ['68.42.66.46']
      
      # Ensure assets are served properly
      c.enable_advanced_debugging_tools = true
    end
  end
end
