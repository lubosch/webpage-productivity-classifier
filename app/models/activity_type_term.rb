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
#  type                    :string
#

class ActivityTypeTerm < ActiveRecord::Base
  belongs_to :activity_type
  belongs_to :term


  # def recalculate_probability(sum)
  #   update_attribute(:probability, self.count / sum.to_f)
  #   update_attribute(:multinomial_probability, self.count+1 / sum.to_f+1)
  # end

end
