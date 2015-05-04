# == Schema Information
#
# Table name: domains
#
#  id         :integer          not null, primary key
#  name       :string
#  eval_type  :string
#  lang       :string
#  domain_id  :integer
#  eval_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Domain < ActiveRecord::Base
  belongs_to :domain
  has_many :domain_terms, primary_key: :eval_id
  has_many :labels, primary_key: :eval_id
end
