class ExtensionApi::ActivePagesController < ExtensionApiController

  prepend_before_filter :load_user

  def tab_change
    new_page = @user.user_application_pages.where(tab_id: params[:tab_id]).last
    old_page = @user.user_application_pages.where(tab_id: params[:previous_tab_id]).last if params[:previous_tab_id].present?
    new_page.tab_change(old_page, request.remote_ip) if new_page && old_page != new_page
    render_200
  end

  def page_lost_focus
    app_act = @user.user_application_pages.where(tab_id: params[:tab_id]).last
    app_act.log_activity(params) if app_act
    render_200
  end

  def chrome_activated
    app_act = @user.user_application_pages.where(tab_id: params[:tab_id]).last
    @user.user_application_pages.create(user: @user, application_page: app_act.application_page, tab_id: app_act.tab_id, app_type: app_act.app_type) if app_act && !app_act.active?
    render_200
  end

  def new_page
    ap = ApplicationPage.find_or_create_by_params(params)
    @user.user_application_pages.create(application_page: ap, tab_id: params[:tab_id], app_type: params[:app_type], ip: request.remote_ip)
    render_200
  end

  def load_user
    @user = current_user
    render_401 unless @user
  end

end
