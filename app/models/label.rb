# == Schema Information
#
# Table name: labels
#
#  id                   :integer          not null, primary key
#  eval_id              :integer
#  application_id       :integer
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
  belongs_to :application, primary_key: :eval_id

  scope :no_test, -> { where(:application => Application.no_test) }
  scope :test, -> { where(:application => Application.test) }

  def categories
    ActivityType::ACTIVITY_TYPES.select { |at| self[at].to_i > 0 }
  end

end
