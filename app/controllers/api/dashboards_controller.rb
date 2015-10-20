class Api::DashboardsController < ApplicationController

  before_action :set_user

  #user
  def overview
    @activities = @user.user_application_pages.today.includes(:application_page )
    @groups = @user.user_application_pages.joins(:application_page => :application).today.pluck(:application_id, :name).uniq
  end


  protected

  def set_user
    @user = current_user
  end

end
