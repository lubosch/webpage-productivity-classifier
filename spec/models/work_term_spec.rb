# == Schema Information
#
# Table name: work_terms
#
#  id                      :integer          not null, primary key
#  term_id                 :integer
#  work_id                 :integer
#  tf                      :integer
#  probability             :float
#  multinomial_probability :float
#  term_type               :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe WorkTerm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
