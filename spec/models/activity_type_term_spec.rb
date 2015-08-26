# == Schema Information
#
# Table name: activity_type_terms
#
#  id                      :integer          not null, primary key
#  activity_type_id        :integer
#  term_id                 :integer
#  tf                      :integer
#  probability             :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  multinomial_probability :float
#

require 'rails_helper'

RSpec.describe ActivityTypeTerm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
