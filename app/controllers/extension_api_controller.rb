class ExtensionApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def current_user
    # binding.pry
    @current_user ||= User.find(doorkeeper_token[:resource_owner_id]) if doorkeeper_token
  end

end
