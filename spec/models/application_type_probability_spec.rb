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

require 'rails_helper'

RSpec.describe ApplicationTypeProbability, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
