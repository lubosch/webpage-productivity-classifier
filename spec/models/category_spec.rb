# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :text
#  count           :integer
#  probability     :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  vocabulary_size :integer
#  terms_count     :integer
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
