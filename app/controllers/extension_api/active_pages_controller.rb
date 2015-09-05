class ExtensionApi::ActivePagesController < ApplicationController

  before_action :load_user

  def tab_change
    binding.pry
    render_200

  end

  def page_lost_focus
    ap = ApplicationPage.find_by(url: params[:url])
    app_act = @user.user_application_pages.where(application_page: ap).last
    app_act.length = params[:active_length].to_i
    app_act.scroll_count = params[:scroll_count].to_i
    app_act.save
    render_200
  end

  def chrome_closed
    #   app_activity = @user.user_application_pages.last
    #   app_activity.application
    #   app_activity.length ||= DateTime.current.to_i - app_activity.created_at.to_i
    #   app_activity.save
    render_200
  end

  def new_page
    ap = ApplicationPage.find_or_create_by_params(params)
    user_activity = UserApplicationPage.create(user: @user, application_page: ap, tab_id: tab_id)
    render_200
  end

  def load_user
    @user = current_user
  end

end
