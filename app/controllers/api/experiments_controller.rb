class Api::ExperimentsController < ApplicationController

  before_action :set_user

  #user
  def application_list
    @applications = @user.best_unclassified_apps
  end

  protected

  def set_user
    @user = current_user
  end

end
