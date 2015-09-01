# == Schema Information
#
# Table name: user_application_pages
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  application_page_id :integer
#  user_id             :integer
#  length              :integer
#  scroll_count        :integer
#  scroll_diff         :integer
#  tab_id              :integer
#  type                :integer
#

class UserApplicationPage < ActiveRecord::Base

  belongs_to :application_page
  belongs_to :user

end
