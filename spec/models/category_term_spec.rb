# == Schema Information
#
# Table name: category_terms
#
#  id          :integer          not null, primary key
#  category_id :integer
#  term_id     :integer
#  count       :integer
#  probability :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe CategoryTerm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
