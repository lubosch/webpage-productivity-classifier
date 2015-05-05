# == Schema Information
#
# Table name: category_domains
#
#  id          :integer          not null, primary key
#  category_id :integer
#  domain_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe CategoryDomain, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
