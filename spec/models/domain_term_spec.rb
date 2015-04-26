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

require 'rails_helper'

RSpec.describe DomainTerm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
