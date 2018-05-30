class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name , :user_type])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name ])
  end

  private
    # This is the method that'll be called if Pundit un-authorizes the user
    def user_not_authorized
      redirect_to((request.referrer || root_path) ,notice: "Authorization error.")
    end
end
