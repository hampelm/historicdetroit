class ApplicationController < ActionController::Base
  before_action do
    Rack::MiniProfiler.authorize_request if current_user&.admin
  end
end
