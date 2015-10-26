Dir[Rails.root.join("spec/factories/*.rb")].each { |f| require f }

FactoryGirl.create(:admin)
ActivityType::ACTIVITY_TYPES.each do |type|
  ActivityType.where(name: type).first_or_create(count: 0, probability: 0.1, vocabulary_size: 0, terms_count: 0, default_multinomial: 0)
end
