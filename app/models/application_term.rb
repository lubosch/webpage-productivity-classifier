# == Schema Information
#
# Table name: application_terms
#
#  id                  :integer          not null, primary key
#  application_page_id :integer
#  term_id             :integer
#  tf                  :integer
#  term_type           :string
#

class ApplicationTerm < ActiveRecord::Base
  belongs_to :application #, primary_key: :eval_id, foreign_key: :application_page_id
  belongs_to :application_page
  belongs_to :term

  delegate :text, to: :term, prefix: true
  delegate :probability, to: :term, prefix: true

  scope :titles, -> { where(term_type: 'title') }
  scope :descriptions, -> { where(term_type: 'description') }
  scope :headers, -> { where(term_type: 'header') }
  scope :texts, -> { where(term_type: 'text') }

  TERM_TYPES = {title: 'title', header: 'header', text: 'text', description: 'description'}

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

  def weight
    case term_type
      when TERM_TYPES[:title]
        1.0
      when TERM_TYPES[:header]
        0.5
      when TERM_TYPES[:text]
        0.1
      when TERM_TYPES[description]
        0.8
      else
        0.0
    end
  end


end
