# == Schema Information
#
# Table name: terms
#
#  id         :integer          not null, primary key
#  eval_id    :integer
#  text       :string
#  tf         :integer
#  df         :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Term < ActiveRecord::Base
end
