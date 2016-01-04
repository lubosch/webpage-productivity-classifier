class Api::DashboardsController < ApplicationController

  before_action :set_user

  #user
  def overview
    @activities = @user.user_application_pages.today.includes(:application_page )
    @groups = @user.user_application_pages.joins(:application_page => :application).today.group(:application_id, :name).pluck('application_id, name, count(*)').sort_by {|app| -app[2]}
  end


  protected

  def set_user
    @user = current_user
  end

end
