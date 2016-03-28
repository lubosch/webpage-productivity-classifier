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
#  term_type               :string
#

class ActivityTypeTerm < ActiveRecord::Base
  belongs_to :activity_type
  belongs_to :term

end
