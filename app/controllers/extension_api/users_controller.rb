class ExtensionApi::UsersController < ApplicationController

  def profile
    @user = current_user
    binding.pry
    if @user
      render json: @user
    else
      render_401
    end
  end

end