# == Schema Information
#
# Table name: application_pages
#
#  id             :integer          not null, primary key
#  application_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ApplicationPage < ActiveRecord::Base
  belongs_to :application
end
