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

require 'rails_helper'

RSpec.describe ApplicationActivityType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
