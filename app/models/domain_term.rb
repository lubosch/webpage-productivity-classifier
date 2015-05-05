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

end
