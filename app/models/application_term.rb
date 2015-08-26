# == Schema Information
#
# Table name: application_terms
#
#  id                  :integer          not null, primary key
#  application_page_id :integer
#  term_id             :integer
#  tf                  :integer
#

class ApplicationTerm < ActiveRecord::Base
  belongs_to :application, primary_key: :eval_id, foreign_key: :application_page_id
  belongs_to :application_page
  belongs_to :term, primary_key: :eval_id

  delegate :text, to: :term, prefix: true
  delegate :probability, to: :term, prefix: true


  def generating_bernouolli_likelihood(category)
    pk = term.activity_type_terms.find { |att| att.activity_type_id == category.id } if term
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

  def generating_multinomial_likelihood(activity_type)
    pk = term.activity_type_terms.find { |att| att.activity_type_id == activity_type.id } if term
    if pk.present?
      pk = pk.multinomial_probability
    else
      pk = 1 / (activity_type.terms_count + activity_type.vocabulary_size.to_f)
    end
    self.tf * Math.log2(pk)
  end


end
