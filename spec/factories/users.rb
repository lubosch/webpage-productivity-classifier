# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  lname                  :string
#  fname                  :string
#  username               :string
#  desktop_logger         :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password {Faker::Internet.password(8)}

    factory :admin do
      email 'admin@admin.com'
      password "adminadmin"
      initialize_with {User.find_or_initialize_by(email: email)}
    end

    factory :default do
      email 'default@default.com'
      password "defaultdefault"
    end

  end
end
