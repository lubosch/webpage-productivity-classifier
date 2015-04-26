# == Schema Information
#
# Table name: domains
#
#  id         :integer          not null, primary key
#  name       :string
#  eval_type  :string
#  domain_id  :integer
#  alter_id   :integer
#  eval_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Domain < ActiveRecord::Base
  belongs_to :domain
end
