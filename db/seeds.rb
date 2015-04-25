Dir[Rails.root.join("spec/factories/*.rb")].each { |f| require f }

FactoryGirl.create(:admin)
