# == Schema Information
#
# Table name: application_terms
#
#  id                  :integer          not null, primary key
#  application_page_id :integer
#  term_id             :integer
#  tf                  :integer
#  type                :string
#

require 'rails_helper'

RSpec.describe ApplicationTerm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
