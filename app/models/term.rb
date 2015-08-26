# == Schema Information
#
# Table name: terms
#
#  id          :integer          not null, primary key
#  eval_id     :integer
#  text        :string
#  ttf         :integer
#  df          :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  probability :decimal(, )
#

class Term < ActiveRecord::Base

  has_many :activity_type_terms
  has_many :application_terms

  def self.update_probabilities
    sum = Term.sum(:tf)
    Term.update_all("probability = ttf / #{sum.to_f}")
  end

end
