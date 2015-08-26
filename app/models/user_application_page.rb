# == Schema Information
#
# Table name: user_application_pages
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  application_page_id :integer
#  user_id             :integer
#

class UserApplicationPage < ActiveRecord::Base
end
