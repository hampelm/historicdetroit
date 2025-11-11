# Log full exception backtraces to help with debugging on Heroku
module ExceptionLogger
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue => exception
      # Log the full exception with backtrace
      Rails.logger.error "=" * 80
      Rails.logger.error "EXCEPTION CAUGHT: #{exception.class}"
      Rails.logger.error "MESSAGE: #{exception.message}"
      Rails.logger.error "BACKTRACE:"
      Rails.logger.error exception.backtrace.join("\n")
      Rails.logger.error "=" * 80
      
      # Re-raise the exception so Rails can handle it normally
      raise exception
    end
  end
end

Rails.application.config.middleware.insert_before(
  ActionDispatch::ShowExceptions,
  ExceptionLogger::Middleware
)
