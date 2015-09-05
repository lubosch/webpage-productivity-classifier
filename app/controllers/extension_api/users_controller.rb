class ExtensionApi::UsersController < ExtensionApiController

  def profile
    @user = current_user
    if @user
      render json: @user
    else
      render_401
    end
  end

end