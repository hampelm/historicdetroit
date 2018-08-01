class ApplicationController < ActionController::Base
  before_action do
    if current_user && current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end
end
