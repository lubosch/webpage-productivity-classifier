class Api::ExperimentsController < ApplicationController
  respond_to :json

  before_action :set_user

  #user
  def application_list
    @applications = @user.best_unclassified_apps
  end

  def application_types
    render json: ActivityType.select(:id, :name)
  end

  #user
  def app_categorization
    ApplicationActivityType.define_by_user(params[:result], @user)
    render_200
  end

  protected

  def set_user
    @user = current_user
  end

end
