# == Schema Information
#
# Table name: labels
#
#  id                   :integer          not null, primary key
#  eval_id              :integer
#  www_id               :integer
#  nowww_id             :integer
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
  belongs_to :domain, :foreign_key => :www_id, primary_key: :eval_id
  belongs_to :nowww_domain, :foreign_key => :nowww_id, primary_key: :eval_id
end
