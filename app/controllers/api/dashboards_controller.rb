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

  def spiral
    data = {}
    r = Random.new

    data['10.4.2016'.to_datetime.change(hour: 21)] = {positive: 70, negative: 30}
    data['10.4.2016'.to_datetime.change(hour: 22)] = {positive: 66, negative: 34}
    data['10.4.2016'.to_datetime.change(hour: 23)] = {positive: 60, negative: 40}

    data['11.4.2016'.to_datetime.change(hour: 0)] = {positive: 20, negative: 80}
    data['11.4.2016'.to_datetime.change(hour: 1)] = {positive: 90, negative: 10}
    data['11.4.2016'.to_datetime.change(hour: 2)] = {positive: 80, negative: 20}
    data['11.4.2016'.to_datetime.change(hour: 3)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 4)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 5)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 6)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 7)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 8)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 9)] = {positive: 20, negative: 80}
    data['11.4.2016'.to_datetime.change(hour: 10)] = {positive: 20, negative: 80}
    data['11.4.2016'.to_datetime.change(hour: 11)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 12)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 13)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 14)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 15)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 16)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 17)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 18)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 19)] = {positive: 0, negative: 0}
    data['11.4.2016'.to_datetime.change(hour: 20)] = {positive: 50, negative: 50}
    data['11.4.2016'.to_datetime.change(hour: 21)] = {positive: 70, negative: 30}
    data['11.4.2016'.to_datetime.change(hour: 22)] = {positive: 80, negative: 20}
    data['11.4.2016'.to_datetime.change(hour: 23)] = {positive: 70, negative: 30}

    data['12.4.2016'.to_datetime.change(hour: 0)] = {positive: 20, negative: 80}
    data['12.4.2016'.to_datetime.change(hour: 1)] = {positive: 30, negative: 70}
    data['12.4.2016'.to_datetime.change(hour: 2)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 3)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 4)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 5)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 6)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 7)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 8)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 9)] = {positive: 10, negative: 90}
    data['12.4.2016'.to_datetime.change(hour: 10)] = {positive: 10, negative: 90}
    data['12.4.2016'.to_datetime.change(hour: 11)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 12)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 13)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 14)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 15)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 16)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 17)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 18)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 19)] = {positive: 0, negative: 0}
    data['12.4.2016'.to_datetime.change(hour: 20)] = {positive: 40, negative: 60}
    data['12.4.2016'.to_datetime.change(hour: 21)] = {positive: 80, negative: 20}
    data['12.4.2016'.to_datetime.change(hour: 22)] = {positive: 86, negative: 14}
    data['12.4.2016'.to_datetime.change(hour: 23)] = {positive: 75, negative: 25}


    data['13.4.2016'.to_datetime.change(hour: 0)] = {positive: 60, negative: 40}
    data['13.4.2016'.to_datetime.change(hour: 1)] = {positive: 70, negative: 30}
    data['13.4.2016'.to_datetime.change(hour: 2)] = {positive: 54, negative: 46}
    data['13.4.2016'.to_datetime.change(hour: 3)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 4)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 5)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 6)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 7)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 8)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 9)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 10)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 11)] = {positive: 8, negative: 92}
    data['13.4.2016'.to_datetime.change(hour: 12)] = {positive: 13, negative: 87}
    data['13.4.2016'.to_datetime.change(hour: 13)] = {positive: 90, negative: 10}
    data['13.4.2016'.to_datetime.change(hour: 14)] = {positive: 85, negative: 15}
    data['13.4.2016'.to_datetime.change(hour: 15)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 16)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 17)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 18)] = {positive: 0, negative: 0}
    data['13.4.2016'.to_datetime.change(hour: 19)] = {positive: 30, negative: 70}
    data['13.4.2016'.to_datetime.change(hour: 20)] = {positive: 60, negative: 40}
    data['13.4.2016'.to_datetime.change(hour: 21)] = {positive: 45, negative: 55}
    data['13.4.2016'.to_datetime.change(hour: 22)] = {positive: 40, negative: 60}
    data['13.4.2016'.to_datetime.change(hour: 23)] = {positive: 20, negative: 80}


    data['14.4.2016'.to_datetime.change(hour: 0)] = {positive: 10, negative: 90}
    data['14.4.2016'.to_datetime.change(hour: 1)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 2)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 3)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 4)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 5)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 6)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 7)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 8)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 9)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 10)] = {positive: 20, negative: 80}
    data['14.4.2016'.to_datetime.change(hour: 11)] = {positive: 60, negative: 40}
    data['14.4.2016'.to_datetime.change(hour: 12)] = {positive: 30, negative: 70}
    data['14.4.2016'.to_datetime.change(hour: 13)] = {positive: 40, negative: 60}
    data['14.4.2016'.to_datetime.change(hour: 14)] = {positive: 70, negative: 30}
    data['14.4.2016'.to_datetime.change(hour: 15)] = {positive: 65, negative: 35}
    data['14.4.2016'.to_datetime.change(hour: 16)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 17)] = {positive: 0, negative: 0}
    data['14.4.2016'.to_datetime.change(hour: 18)] = {positive: 65, negative: 35}
    data['14.4.2016'.to_datetime.change(hour: 19)] = {positive: 35, negative: 65}
    data['14.4.2016'.to_datetime.change(hour: 20)] = {positive: 80, negative: 20}
    data['14.4.2016'.to_datetime.change(hour: 21)] = {positive: 75, negative: 25}
    data['14.4.2016'.to_datetime.change(hour: 22)] = {positive: 70, negative: 30}
    data['14.4.2016'.to_datetime.change(hour: 23)] = {positive: 30, negative: 70}


    data['15.4.2016'.to_datetime.change(hour: 0)] = {positive: 20, negative: 60}
    data['15.4.2016'.to_datetime.change(hour: 1)] = {positive: 40, negative: 60}
    data['15.4.2016'.to_datetime.change(hour: 2)] = {positive: 30, negative: 70}
    data['15.4.2016'.to_datetime.change(hour: 3)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 4)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 5)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 6)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 7)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 8)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 9)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 10)] = {positive: 10, negative: 90}
    data['15.4.2016'.to_datetime.change(hour: 11)] = {positive: 10, negative: 90}
    data['15.4.2016'.to_datetime.change(hour: 12)] = {positive: 30, negative: 70}
    data['15.4.2016'.to_datetime.change(hour: 13)] = {positive: 60, negative: 40}
    data['15.4.2016'.to_datetime.change(hour: 14)] = {positive: 65, negative: 35}
    data['15.4.2016'.to_datetime.change(hour: 15)] = {positive: 60, negative: 40}
    data['15.4.2016'.to_datetime.change(hour: 16)] = {positive: 70, negative: 30}
    data['15.4.2016'.to_datetime.change(hour: 17)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 18)] = {positive: 10, negative: 90}
    data['15.4.2016'.to_datetime.change(hour: 19)] = {positive: 20, negative: 80}
    data['15.4.2016'.to_datetime.change(hour: 20)] = {positive: 40, negative: 60}
    data['15.4.2016'.to_datetime.change(hour: 21)] = {positive: 30, negative: 70}
    data['15.4.2016'.to_datetime.change(hour: 22)] = {positive: 0, negative: 0}
    data['15.4.2016'.to_datetime.change(hour: 23)] = {positive: 0, negative: 0}


    data['16.4.2016'.to_datetime.change(hour: 0)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 1)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 2)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 3)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 4)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 5)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 6)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 7)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 8)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 9)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 10)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 11)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 12)] = {positive: 20, negative: 80}
    data['16.4.2016'.to_datetime.change(hour: 13)] = {positive: 20, negative: 80}
    data['16.4.2016'.to_datetime.change(hour: 14)] = {positive: 0, negative: 0}
    data['16.4.2016'.to_datetime.change(hour: 15)] = {positive: 40, negative: 60}
    data['16.4.2016'.to_datetime.change(hour: 16)] = {positive: 80, negative: 20}
    data['16.4.2016'.to_datetime.change(hour: 17)] = {positive: 76, negative: 24}
    data['16.4.2016'.to_datetime.change(hour: 18)] = {positive: 80, negative: 20}
    data['16.4.2016'.to_datetime.change(hour: 19)] = {positive: 70, negative: 30}
    data['16.4.2016'.to_datetime.change(hour: 20)] = {positive: 60, negative: 40}
    data['16.4.2016'.to_datetime.change(hour: 21)] = {positive: 75, negative: 25}
    data['16.4.2016'.to_datetime.change(hour: 22)] = {positive: 60, negative: 40}
    data['16.4.2016'.to_datetime.change(hour: 23)] = {positive: 20, negative: 80}


    data['17.4.2016'.to_datetime.change(hour: 0)] = {positive: 00, negative: 100}
    data['17.4.2016'.to_datetime.change(hour: 1)] = {positive: 00, negative: 100}
    data['17.4.2016'.to_datetime.change(hour: 2)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 3)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 4)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 5)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 6)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 7)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 8)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 9)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 10)] = {positive: 20, negative: 80}
    data['17.4.2016'.to_datetime.change(hour: 11)] = {positive: 30, negative: 70}
    data['17.4.2016'.to_datetime.change(hour: 12)] = {positive: 10, negative: 90}
    data['17.4.2016'.to_datetime.change(hour: 13)] = {positive: 70, negative: 30}
    data['17.4.2016'.to_datetime.change(hour: 14)] = {positive: 80, negative: 20}
    data['17.4.2016'.to_datetime.change(hour: 15)] = {positive: 10, negative: 90}
    data['17.4.2016'.to_datetime.change(hour: 16)] = {positive: 10, negative: 90}
    data['17.4.2016'.to_datetime.change(hour: 17)] = {positive: 80, negative: 20}
    data['17.4.2016'.to_datetime.change(hour: 18)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 19)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 20)] = {positive: 60, negative: 40}
    data['17.4.2016'.to_datetime.change(hour: 21)] = {positive: 30, negative: 70}
    data['17.4.2016'.to_datetime.change(hour: 22)] = {positive: 0, negative: 0}
    data['17.4.2016'.to_datetime.change(hour: 23)] = {positive: 10, negative: 90}

    data['18.4.2016'.to_datetime.change(hour: 0)] = {positive: 0, negative: 0}


    render json: data

  end

  protected

  def set_user
    @user = current_user
  end

end
