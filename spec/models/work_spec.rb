# == Schema Information
#
# Table name: works
#
#  id                  :integer          not null, primary key
#  name                :string
#  count               :integer
#  probability         :float
#  vocabulary_size     :integer
#  terms_count         :integer
#  default_multinomial :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Work, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
