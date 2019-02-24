class ApplicationController < ActionController::Base
  helper_method :admin?

  before_action do
  end

  def admin?
    current_user.try(:admin?)
  end
end
