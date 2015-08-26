# == Schema Information
#
# Table name: application_activity_types
#
#  id               :integer          not null, primary key
#  activity_type_id :integer
#  application_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ApplicationActivityType < ActiveRecord::Base
  belongs_to :activity_type
  belongs_to :application
end
