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

class CategoryDomain < ActiveRecord::Base
  belongs_to :category
  belongs_to :domain
end
