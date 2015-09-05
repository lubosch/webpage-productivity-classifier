class Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  before_filter :authenticate_user!

end