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
  belongs_to :domain
  belongs_to :term
end
