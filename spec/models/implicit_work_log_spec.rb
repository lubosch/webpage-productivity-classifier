# == Schema Information
#
# Table name: implicit_work_logs
#
#  id         :integer          not null, primary key
#  ip         :string
#  in_work    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'rails_helper'

RSpec.describe ImplicitWorkLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
