# == Schema Information
#
# Table name: terms
#
#  id          :integer          not null, primary key
#  eval_id     :integer
#  text        :string
#  tf          :integer
#  df          :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  probability :decimal(, )
#

require 'rails_helper'

RSpec.describe Term, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
