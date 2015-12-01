# == Schema Information
#
# Table name: implicit_work_logs
#
#  id         :integer          not null, primary key
#  ip         :string
#  in_work    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImplicitWorkLog < ActiveRecord::Base
end
