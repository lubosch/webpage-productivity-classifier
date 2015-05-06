# == Schema Information
#
# Table name: domain_terms
#
#  id        :integer          not null, primary key
#  domain_id :integer
#  term_id   :integer
#  tf        :integer
#  df        :integer
#

class DomainTerm < ActiveRecord::Base
  belongs_to :domain, primary_key: :eval_id
  belongs_to :term, primary_key: :eval_id

  delegate :text, to: :term, prefix: true
  delegate :probability, to: :term, prefix: true


  def generating_likelihood(category)
    category
    pk = term.category_terms.find { |ct| ct.category_id == category.id } if term
    if pk.present?
      pk = pk.probability
      xi = 0
    else
      pk = term ? term.probability : 0.0000000000001
      xi = 1
    end
    self.tf * Math.log10(pk**xi * (1-pk)**(1-xi))

  end

end
