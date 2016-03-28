# == Schema Information
#
# Table name: application_type_probabilities
#
#  id                  :integer          not null, primary key
#  application_id      :integer
#  activity_type_id    :integer
#  method              :string
#  value               :float
#  application_page_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ApplicationTypeProbability < ActiveRecord::Base
  belongs_to :application
  belongs_to :activity_type
  belongs_to :application_page
end
