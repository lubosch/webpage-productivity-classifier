class Api::DashboardsController < ApplicationController

  before_action :set_user

  #user
  def overview
    @activities = @user.user_application_pages.today.includes(:application_page)
    @groups = @user.user_application_pages.joins(:application_page => :application).today.group(:application_id, :name).pluck('application_id, name, count(*), sum(length)').sort_by { |app| -app[2] }
  end

  def words_cloud
    # stats = @user.apps_w_stats(24.hours.ago, 1.minute.ago)
    result = {}
    @user.user_application_pages.includes(:application_page => {:application_terms => :term}).ranged(24.hours.ago, DateTime.now).each do |uap|
      uap.application_terms.each do |app_term|
        if result[app_term.term_id]
          result[app_term.term_id] = {count: result[app_term.term_id][:count]+1, weight: result[app_term.term_id][:weight]+app_term.weight*uap.length/60.0, text: app_term.term_text}
        else
          result[app_term.term_id] = {count: 1, weight: app_term.weight*uap.length/100.0, text: app_term.term_text}
        end
      end
    end
    # binding.pry
    render json: {words_cloud: result.map {|id, app| app}.sort_by {|app| app[:weight]}.reverse}
  end

  protected

  def set_user
    @user = current_user
  end

end
