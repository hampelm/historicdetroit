class ApplicationController < ActionController::Base
  helper_method :admin?

  # Log full exception traces in production
  rescue_from StandardError do |exception|
    Rails.logger.error "=" * 80
    Rails.logger.error "EXCEPTION IN CONTROLLER: #{exception.class}"
    Rails.logger.error "MESSAGE: #{exception.message}"
    Rails.logger.error "BACKTRACE:"
    Rails.logger.error exception.backtrace.join("\n")
    Rails.logger.error "=" * 80
    
    # Re-raise so Rails handles it normally (shows error page, etc)
    raise exception
  end

  before_action do
  end

  def admin?
    current_user.try(:admin?)
  end
end
