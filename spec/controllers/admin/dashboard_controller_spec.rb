require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do

  describe "GET #training" do
    it "returns http success" do
      get :training
      expect(response).to have_http_status(:success)
    end
  end

end
