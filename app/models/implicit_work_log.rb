# == Schema Information
#
# Table name: implicit_work_logs
#
#  id         :integer          not null, primary key
#  ip         :string
#  in_work    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class ImplicitWorkLog < ActiveRecord::Base
  belongs_to :user
  IN_WORK = 1
  NOT_IN_WORK = 0

  def self.set_in_work(user, ip)
    create(user: user, in_work: IN_WORK, ip: ip)
  end

  def self.set_not_in_work(user, ip)
    create(user: user, in_work: NOT_IN_WORK, ip: ip)
  end

end
