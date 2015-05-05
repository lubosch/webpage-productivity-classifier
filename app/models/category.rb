# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :text
#  count       :integer
#  probability :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Category < ActiveRecord::Base
end
