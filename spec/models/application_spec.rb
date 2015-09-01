# == Schema Information
#
# Table name: applications
#
#  id          :integer          not null, primary key
#  name        :string
#  eval_type   :string
#  lang        :string
#  eval_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  url         :string
#  static      :integer
#  user_static :integer
#

require 'rails_helper'

RSpec.describe Application, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
