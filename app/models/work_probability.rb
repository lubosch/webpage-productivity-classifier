# == Schema Information
#
# Table name: work_probabilities
#
#  id                  :integer          not null, primary key
#  application_id      :integer
#  work_id             :integer
#  method              :string
#  value               :float
#  application_page_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class WorkProbability < ActiveRecord::Base
  belongs_to :application
  belongs_to :work
  belongs_to :application_page
end
