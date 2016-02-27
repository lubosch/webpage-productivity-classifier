class Api::DashboardsController < ApplicationController

  before_action :set_user

  #user
  def overview
    @activity_terms = Hash[ApplicationTerm.where(application_page_id: @user.user_application_pages.ranged(params[:start_day].to_datetime, params[:end_day].to_datetime).joins(:application_page).pluck(:application_page_id)).joins(:term).where("term_type = 'title'").group('application_terms.application_page_id').pluck("application_terms.application_page_id, string_agg(terms.text,' ')")]
    @activities = @user.user_application_pages.ranged(params[:start_day].to_datetime, params[:end_day].to_datetime).includes(:application_page)
    @groups = @user.user_application_pages.joins(:application_page => :application).ranged(params[:start_day].to_datetime, params[:end_day].to_datetime).group(:application_id, :name).pluck('application_id, name, count(*), sum(length)').sort_by { |app| -app[3] }
  end

  def words_cloud
    @words_cloud = @user.user_application_pages.includes(:application_page => {:application_terms => :term}).ranged(params[:start_day].to_datetime, params[:end_day].to_datetime)
  end

  protected

  def set_user
    @user = current_user
  end

end
