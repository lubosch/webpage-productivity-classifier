class ExtensionApi::ExperimentsController < ExtensionApiController
  prepend_before_filter :load_user

  respond_to :json

  #user
  def in_work
    ImplicitWorkLog.set_in_work(@user, request.remote_ip)
    render_200
  end


  def not_in_work
    ImplicitWorkLog.set_not_in_work(@user, request.remote_ip)
    render_200
  end

  def beer_count
    render json: { 'beer_count' => @user.application_activity_types.count / 30.0 }
  end

  protected

  def load_user
    @user = current_user
    render_401 unless @user
  end
end
