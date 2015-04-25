module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      admin = FactoryGirl.create(:admin)
      sign_in :user, admin # Using factory girl as an example
    end
  end

  def login_default
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:default]
      user = FactoryGirl.create(:default)
      user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end

end