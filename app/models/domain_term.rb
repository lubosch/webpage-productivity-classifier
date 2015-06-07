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


  def generating_bernouolli_likelihood(category)
    pk = term.category_terms.find { |ct| ct.category_id == category.id } if term
    if pk.present?
      pk = pk.probability
      xi = 0
    else
      pk = term ? term.probability : 0.0001
      xi = 1
    end
    #self.tf *
    (xi*Math.log2(pk) + (1-xi)*Math.log2((1-pk)))
  end

  def generating_multinomial_likelihood(category)
    pk = term.category_terms.find { |ct| ct.category_id == category.id } if term
    if pk.present?
      pk = pk.multinomial_probability
    else
      pk = 1 / (category.terms_count + category.vocabulary_size.to_f)
    end
    self.tf * Math.log2(pk)
  end


end
