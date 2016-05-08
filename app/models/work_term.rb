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

class WorkTerm < ActiveRecord::Base
  belongs_to :work
  belongs_to :term



end
