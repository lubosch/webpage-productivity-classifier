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

class Work < ActiveRecord::Base

  has_many :work_terms
  has_many :application_activity_types

  WORK_TYPES = {work: 'work', non_work: 'non-work'}

end
