# == Schema Information
#
# Table name: labels
#
#  id                   :integer          not null, primary key
#  eval_id              :integer
#  domain_id            :integer
#  assessor_id          :integer
#  adult                :integer
#  spam                 :integer
#  news_editorial       :integer
#  commercial           :integer
#  educational_research :integer
#  discussion           :integer
#  personal_leisure     :integer
#  media                :integer
#  database             :integer
#  readability_vis      :integer
#  readability_lang     :integer
#  neutrality           :integer
#  bias                 :integer
#  trustiness           :integer
#  confidence           :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Label < ActiveRecord::Base
  belongs_to :domain, primary_key: :eval_id

  scope :no_test, -> { where(:domain => Domain.no_test) }
  scope :test, -> { where(:domain => Domain.test) }

end
