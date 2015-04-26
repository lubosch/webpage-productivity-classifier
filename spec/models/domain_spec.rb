# == Schema Information
#
# Table name: domains
#
#  id         :integer          not null, primary key
#  name       :string
#  eval_type  :string
#  domain_id  :integer
#  alter_id   :integer
#  eval_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Domain, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
