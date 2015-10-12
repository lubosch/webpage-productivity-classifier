class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  after_filter :prepare_unobtrusive_flash

  def render_200
    respond_to do |format|
      format.any { head :ok }
      format.html { render :file => "#{Rails.root}/public/200", :layout => false, :status => :not_found }
    end
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.any { head :not_found }
    end
  end

  def render_401
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/403", :layout => false, :status => 401 }
      format.any { head :unauthorized }
    end
  end

  def render_500
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :not_found }
      format.any { head :no_access }
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    render_401
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || profile_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :roles) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def set_locale
    begin
      if params["lang"]
        # Symbol conversion from unsafe string (potential dos vulnerability)
        language = params["lang"].to_sym
        I18n.locale = language
        cookies["lang"] = language
      else
        I18n.locale = cookies["lang"] || http_accept_language.compatible_language_from(I18n.available_locales)
      end

    rescue I18n::InvalidLocale => e
      I18n.locale = I18n.default_locale
    end
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end


end
