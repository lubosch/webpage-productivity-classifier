# == Schema Information
#
# Table name: application_pages
#
#  id             :integer          not null, primary key
#  application_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  url            :string
#  static         :integer
#  user_static    :integer
#

require 'rails_helper'

RSpec.describe ApplicationPage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
