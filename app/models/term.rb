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

class Term < ActiveRecord::Base

  has_many :category_terms
  has_many :domain_terms

  def self.update_probabilities
    sum = Term.sum(:tf)
    Term.update_all("probability = tf / #{sum.to_f}")
  end

end
